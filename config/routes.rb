# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  # OmniAuth routing
  get 'auth/github/callback', to: 'omniauth_callbacks#github'
  get 'auth/google_oauth2/callback', to: 'omniauth_callbacks#google_oauth2'
  get 'auth/failure', to: redirect('/')
  delete :sign_out, to: 'sessions#destroy'

  resources :users, only: :edit do
    scope module: :users do
      resource :preference, only: :update
      resources :notifications, only: %i[show index] do
        collection do
          post :clear
        end
      end
    end
  end

  resources :teams, only: %i[edit new create] do
    post :support

    scope module: :teams do
      resources :users, only: %i[index create destroy]
      resources :topics, only: %i[index show new edit create update] do
        post :subscribe

        scope module: :topics do
          resources :comments, only: %i[index new edit create update] do
            scope module: :comments do
              resources :votes, only: %i[create destroy]
            end
          end

          resources :votes, only: %i[create destroy]
        end
      end
    end
  end
end
