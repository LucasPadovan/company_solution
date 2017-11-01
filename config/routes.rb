Rails.application.routes.draw do
  resources :certificates do
    resources :certificate_details, as: :details
    resources :permissions
  end
  devise_for :users

  resources :products do
    resources :recipes, except: [:index]
    resources :trades, except: [:index, :show]
  end

  resources :firms do
    resources :trades, except: [:index, :show]
    resources :contacts, except: [:index, :show]
    resources :permissions

    member do
      get :products_list
    end
  end

  resources :orders do
    resources :order_lines
    resources :order_statuses
  end

  resources :purchases

  resources :budgets do
    resources :budget_lines
  end

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
