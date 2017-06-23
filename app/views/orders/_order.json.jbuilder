json.extract! order, :id, :number, :tracking_code, :type, :total, :subtotal, :taxes, :deliver_fee, :packaging_fee, :expected_deliver_from, :expected_deliver_to, :firm, :user_id, :contact_name, :date, :created_at, :updated_at
json.url order_url(order, format: :json)
