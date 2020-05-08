json.extract! purchase, :id, :order_id, :supplier_id, :value, :status, :bpm_instance, :created_at, :updated_at
json.url purchase_url(purchase, format: :json)
