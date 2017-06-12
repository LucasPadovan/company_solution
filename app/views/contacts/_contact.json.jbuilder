json.extract! contact, :id, :name, :area, :details, :firm_id, :created_at, :updated_at
json.url contact_url(contact, format: :json)
