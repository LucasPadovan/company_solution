json.extract! product, :id, :name, :description, :area, :user_id, :type, :unit, :initial_stock, :current_stock, :created_at, :updated_at
json.url product_url(product, format: :json)
