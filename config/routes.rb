Rails.application.routes.draw do
  resources :permissions
  resources :certificate_details
  resources :certificates
  devise_for :users

  resources :products do
    resources :recipes, except: [:index]
    resources :trades, except: [:index, :show]
  end

  resources :firms do
    resources :trades, except: [:index, :show]
    resources :contacts, except: [:index, :show]

    member do
      get :products_list
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

  root to: 'orders#index'
end
