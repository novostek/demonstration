json.extract! transaction, :id, :category, :transaction_category_id, :transaction_account_id, :order_id, :origin, :due, :effective, :value, :bpm_instance, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
