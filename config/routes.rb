Rails.application.routes.draw do
  devise_for :users

  resources :products do
    resources :recipes, except: [:index]
  end

  resources :firms

  root to: 'firms#index'
end
