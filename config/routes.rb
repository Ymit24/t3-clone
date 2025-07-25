Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: %i[new create]
  resources :accounts, only: %i[edit update destroy]

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  resources :llm_models, only: %i[index] do
    resources :capabilities, only: %i[index]
  end

  resources :chats, only: %i[new index show destroy] do
    resources :prompts, only: %i[edit update], controller: "chats/prompts"
    resources :messages, only: %i[new show edit create update] do
      resource :retry, only: [ :create ], controller: "messages/retry"
    end
    resource :cancel, only: [ :create ], controller: "chats/cancel"
  end

  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end
  # Add a protected route that requires authentication
  mount MissionControl::Jobs::Engine, at: "/jobs"
end
