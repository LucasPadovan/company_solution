json.extract! order_line, :id, :order_id, :amount, :product_id, :unit_price, :subtotal, :tax_rate, :tax, :remaining_amount, :position, :created_at, :updated_at
json.url order_line_url(order_line, format: :json)
