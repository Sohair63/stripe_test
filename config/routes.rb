# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resource :charges, only: %i[create] do
    post :refund
  end

  post "webhooks/:source", controller: :webhooks, action: :create
  get "webhooks/:source", controller: :webhooks, action: :create
end
