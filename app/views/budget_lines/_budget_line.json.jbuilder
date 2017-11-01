json.extract! budget_line, :id, :budget_id, :product_id, :unit_price, :currency, :tax_rate, :unit, :position, :price_change, :created_at, :updated_at
json.url budget_line_url(budget_line, format: :json)
