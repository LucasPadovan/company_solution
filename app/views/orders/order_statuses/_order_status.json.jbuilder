json.extract! order_status, :id, :status, :order_id, :detail, :created_at, :updated_at
json.url order_status_url(order_status, format: :json)
