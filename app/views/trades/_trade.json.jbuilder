json.extract! trade, :id, :product_id, :sold_by, :sold_to, :from, :to, :created_at, :updated_at
json.url trade_url(trade, format: :json)
