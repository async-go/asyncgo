# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :topics, only: %i[index show new create] do
    scope module: :topics do
      resources :comments, only: %i[new create]
    end
  end

  resources :teams, only: %i[edit update] do
    scope module: :teams do
      resources :users, only: %i[create destroy]
    end
  end
end
