Rails.application.routes.draw do
  devise_for :users

  resources :firms

  root to: 'firms#index'
end
