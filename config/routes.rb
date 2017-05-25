Rails.application.routes.draw do
  resources :recipes
  resources :products
  devise_for :users

  resources :firms

  root to: 'firms#index'
end
