json.extract! product_purchase, :id, :product_id, :purchase_id, :unity_value, :quantity, :value, :status, :custom_title, :created_at, :updated_at
json.url product_purchase_url(product_purchase, format: :json)
