require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :admin do
    mount Blazer::Engine, at: "/blazer"
    mount Sidekiq::Web, at: '/sidekiq'
    if Rails.env.development? || Rails.env.staging?
      mount LetterOpenerWeb::Engine, at: '/letter_opener'
    end
  end

  # app routes
  get "/auth/:provider/callback", to: "sessions#create"
  resource :account, only: [ :show, :destroy ] 
  resource :billing, only: :show
  resource :checkout, only: :show
  resource :home, only: :show
  resource :upload_archive, only: [:show, :create]
  resources :keeps, only: [:index, :update, :destroy] do
    collection do
      post :index
    end
  end
  resource :search, only: :show
  resource :session, only: :destroy
  resources :settings, only: :update
  resource :subscription, only: [:update, :destroy]
  resources :tweets, only: [:index, :show, :destroy] do
    collection do
      post :index
      get :fetch
      get :sweep
    end
  end
  resource :upcoming, only: :show
  resource :upcoming_setting, only: :update

  get "privacy", to: "policies#privacy"
  get "tos", to: "policies#tos"
  root "homes#show"
end
