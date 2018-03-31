Rails.application.routes.draw do
  resources :certificates do
    resources :permissions
  end
  devise_for :users

  resources :products do
    resources :recipes, except: [:index]
    resources :trades, except: [:index, :show]
  end

  resources :firms do
    resources :trades, except: [:show]
    resources :contacts, except: [:index, :show]
    resources :permissions
    resources :budgets

    member do
      get 'products_list', controller: 'trades', action: 'index'
    end
  end

  resources :orders do
    resources :order_lines
    resources :order_statuses
  end

  resources :purchases

  resources :budgets

  resources :trades, only: :show do
    resources :prices, except: [:show, :edit, :update] do
      member do
        put :set_as_available
      end
    end

    collection do
      get :find_product
    end
  end

  resources :permissions, except: [:index]

  root to: 'orders#index'
end
