json.extract! certificate, :id, :name, :description, :website, :email, :wait_time, :notes, :created_at, :updated_at
json.url certificate_url(certificate, format: :json)
