json.extract! budget, :id, :firm_id, :number, :date, :from, :to, :destinatary, :contact, :title, :header_image, :body_image, :pdf_file, :created_at, :updated_at
json.url budget_url(budget, format: :json)
