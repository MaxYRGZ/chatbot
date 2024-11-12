Rails.application.routes.draw do
  post 'chatbot/send_message'
  get 'chatbot/index'
  mount SolidusAdmin::Engine, at: '/admin', constraints: ->(req) {
    req.cookies['solidus_admin'] != 'false' &&
    req.params['solidus_admin'] != 'false'
  }
  scope(path: '/') { draw :storefront }
  # This line mounts Solidus's routes at the root of your application.
  #
  # Unless you manually picked only a subset of Solidus components, this will mount routes for:
  #   - solidus_backend
  #   - solidus_api
  # This means, any requests to URLs such as /admin/products, will go to Spree::Admin::ProductsController.
  #
  # If you are using the Starter Frontend as your frontend, be aware that all the storefront routes are defined
  # separately in this file and are not part of the Solidus::Core::Engine engine.
  #
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  # We ask that you don't use the :as option here, as Solidus relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
