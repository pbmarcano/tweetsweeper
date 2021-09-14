require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope :monitor do
    # Sidekiq Basic Auth from routes on production environment
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_AUTH_USERNAME"])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_AUTH_PASSWORD"]))
    end if Rails.env.production?

    mount Sidekiq::Web, at: '/sidekiq'
  end

  get "/auth/:provider/callback", to: "sessions#create"
  
  resource :billing, only: :show
  resource :checkout, only: :show
  resource :dashboard, only: :show
  resource :home, only: :show
  resource :session, only: :destroy
  resources :settings, only: :update
  resources :tweets, only: :destroy do
    collection do
      get :fetch
    end
  end
  root "homes#show"
end
