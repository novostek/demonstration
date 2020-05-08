json.extract! product_estimate, :id, :product_id, :custom_title, :notes, :unitary_value, :quantity, :discount, :value, :tax, :measurement_proposal_id, :created_at, :updated_at
json.url product_estimate_url(product_estimate, format: :json)
