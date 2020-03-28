json.extract! customer, :id, :name, :category, :document_id, :since, :code, :birthdate, :contacts, :created_at, :updated_at
json.main_email customer.get_main_email_f
json.main_phone customer.get_main_phone_f
json.url customer_url(customer, format: :json)
