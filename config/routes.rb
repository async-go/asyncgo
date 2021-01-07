# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  # OmniAuth routing
  get 'auth/google_oauth2/callback', to: 'omniauth_callbacks#google_oauth2'
  get 'auth/failure', to: redirect('/')
  delete :sign_out, to: 'sessions#destroy'

  resources :teams, only: %i[edit new create] do
    scope module: :teams do
      resources :users, only: %i[create destroy]

      resources :topics, only: %i[index show new edit create update] do
        scope module: :topics do
          resources :comments, only: %i[edit create update]
        end
      end
    end
  end
end
