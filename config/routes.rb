Rails.application.routes.draw do
  devise_for :users

  resources :products do
    resources :recipes, except: [:index]
    resources :trades, except: [:index, :show]
  end

  resources :firms do
    resources :trades, except: [:index, :show]
    resources :contacts, except: [:index, :show]
  end

  root to: 'firms#index'
end
