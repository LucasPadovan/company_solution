Rails.application.routes.draw do
  resources :firms

  root to: 'firms#index'
end
