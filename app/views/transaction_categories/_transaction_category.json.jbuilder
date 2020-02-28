json.extract! transaction_category, :id, :name, :description, :color, :namespace, :created_at, :updated_at
json.url transaction_category_url(transaction_category, format: :json)
