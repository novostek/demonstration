json.extract! client, :id, :name, :tenant_name, :created_at, :updated_at
json.url client_url(client, format: :json)
