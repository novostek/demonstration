json.extract! order, :id, :code, :status, :bpmn_instance, :start_at, :end_at, :created_at, :updated_at
json.url order_url(order, format: :json)
json.customer order.current_estimate.customer
json.location order.current_estimate.location
json.price order.current_estimate.total
json.balance order.balance
json.total_paid order.total_paid
