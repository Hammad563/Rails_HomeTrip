require 'resque/server'
Rails.application.routes.draw do
  
  root to: 'static_pages#home'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :listings, only: [:index, :show]
  resources :reservations
  post '/webhooks/:source' => 'webhooks#create'

  namespace :host do
   resources :listings do
    resources :photos, only: [:index, :create, :destroy] 
    resources :rooms, only: [:index, :create, :destroy]
   end
  end

  resque_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.id == 1
  end

  constraints resque_web_constraint do
    mount Resque::Server, at: '/jobs'
  end
  
end
