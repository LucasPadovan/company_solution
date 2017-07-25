json.extract! price, :id, :trade_id, :price, :min_quantity, :valid_from, :valid_to, :currency, :available, :created_at, :updated_at
json.url price_url(price, format: :json)
