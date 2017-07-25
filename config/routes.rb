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

  resources :orders do
    resources :order_lines
    resources :order_statuses
  end

  resources :trades, only: :show do
    resources :prices, except: :show
  end

  root to: 'firms#index'
end
