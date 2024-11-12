require "openai"

class ChatbotController < ApplicationController
  def index
    @products = Spree::Product.all
  end

  def send_message
    client = OpenAI::Client.new(access_token: Rails.application.credentials.openai.api_key)
    
    products_info = Spree::Product.all.map do |p|
      "#{p.name}: #{p.description&.truncate(100)} - Precio: #{p.price}"
    end.join("\n")
    
    system_message = "Eres un asistente de ventas para una tienda en línea. Responde preguntas sobre los siguientes productos:\n#{products_info}"

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: system_message },
          { role: "user", content: params[:message] }
        ],
        temperature: 0.7,
      })

    render json: { response: response.dig("choices", 0, "message", "content") }
  rescue => e
    Rails.logger.error("Error en ChatbotController#send_message: #{e.message}")
    render json: { error: "Lo siento, ha ocurrido un error. Por favor, intenta de nuevo." }, status: :internal_server_error
  end
end