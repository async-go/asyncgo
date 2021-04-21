# frozen_string_literal: true

require 'sidekiq/web'

class AuthConstraint
  def self.admin?(request)
    user = User.find_by(id: request.session[:user_id])
    user&.email&.ends_with?('@asyncgo.com')
  end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  # OmniAuth routing
  get 'auth/github/callback', to: 'omniauth_callbacks#github'
  get 'auth/google_oauth2/callback', to: 'omniauth_callbacks#google_oauth2'
  get 'auth/microsoft_graph/callback', to: 'omniauth_callbacks#microsoft_graph'
  get 'auth/slack/callback', to: 'omniauth_callbacks#slack'
  get 'auth/failure', to: redirect('/')
  delete :sign_out, to: 'sessions#destroy'

  constraints ->(request) { AuthConstraint.admin?(request) } do
    mount Sidekiq::Web, at: 'sidekiq'
    mount Blazer::Engine, at: 'blazer'
  end

  post 'subscriptions_webhook', to: 'subscriptions#webhook', constraints: { format: 'json' }

  resources :users, only: :edit do
    scope module: :users do
      resource :preferences, only: :update
      resources :notifications, only: %i[show index] do
        collection do
          post :clear
        end
      end
    end
  end

  resources :teams, only: %i[edit new create update] do
    post :support

    scope module: :teams do
      resources :users, only: %i[index create destroy]
      resources :topics, only: %i[index show new edit create update] do
        patch :toggle
        post :subscribe
        patch :pin

        scope module: :topics do
          resources :comments, only: %i[new create edit update] do
            scope module: :comments do
              resources :votes, only: %i[create destroy]
            end
          end

          resources :votes, only: %i[create destroy]
        end
      end

      resource :subscription, only: :edit
    end
  end
end
