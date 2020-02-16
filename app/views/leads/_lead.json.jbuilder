json.extract! lead, :id, :customer_id, :via, :description, :status, :date, :phone, :created_at, :updated_at
json.url lead_url(lead, format: :json)
