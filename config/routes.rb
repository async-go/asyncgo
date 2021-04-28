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
  root controller: :home, action: :index
  delete :sign_out, controller: :sessions, action: :destroy

  # OmniAuth routing
  scope :auth, controller: :omniauth_callbacks do
    get 'github/callback', action: :github
    get 'google_oauth2/callback', action: :google_oauth2
    get 'microsoft_graph/callback', action: :microsoft_graph
    get 'slack/callback', action: :slack

    get :failure, to: redirect('/')
  end

  get 'teams/:team_id/topic/new', to: 'teams/topics#new'

  constraints ->(request) { AuthConstraint.admin?(request) } do
    mount Sidekiq::Web, at: :sidekiq
    mount Blazer::Engine, at: :blazer
  end

  resources :subscriptions, only: [], constraints: { format: :json } do
    collection do
      post :update
    end
  end

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
