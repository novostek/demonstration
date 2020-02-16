json.extract! customer, :id, :name, :category, :document_id, :since, :code, :birthdate, :contacts, :created_at, :updated_at
json.url customer_url(customer, format: :json)
