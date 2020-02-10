json.extract! product, :id, :name, :uuid, :details, :product_category_id, :customer_price, :cost_price, :area_covered, :tax, :bpm_purchase, :created_at, :updated_at
json.url product_url(product, format: :json)
