json.extract! contact, :id, :category, :title, :value, :origin, :origin_id, :created_at, :updated_at
json.url contact_url(contact, format: :json)
