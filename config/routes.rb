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
    resources :prices, except: [:show, :edit, :update]

    collection do
      get :find_product
    end
  end

  get 'budgets', to: 'orders#index', as: :budgets, defaults: { order_type: 'budget' }
  get 'budgets/:id', to: 'orders#show', as: :budget, defaults: { order_type: 'budget' }
  get 'purchases', to: 'orders#index', as: :purchases, defaults: { order_type: 'purchase' }
  get 'purchases/:id', to: 'orders#show', as: :purchase, defaults: { order_type: 'purchase' }

  root to: 'orders#index'
end
