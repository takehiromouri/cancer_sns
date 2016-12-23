Rails.application.routes.draw do
  root 'static#home'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  resources :users, only: :show do
    namespace :friend do
      resources :friendships, only: [:destroy]
      resources :request_accepts, only: [:create, :destroy]
      resources :request_sends, only: [:create, :destroy]
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
