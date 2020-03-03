json.extract! transaction_account, :id, :name, :description, :color, :namespace, :created_at, :updated_at
json.url transaction_account_url(transaction_account, format: :json)
