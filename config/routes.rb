# frozen-string-literal: true

Rails.application.routes.draw do
  resources :posts
  resources :accounts, as: :users, only: %i[show update]

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :friendships, only: %i[create update index]

  post '/custom_sign_up', to: 'users/omniauth_callbacks#custom_sign_up'

  authenticated :user do
    root 'main#home'
  end

  unauthenticated :user do
    root 'main#unregistered'
  end

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
