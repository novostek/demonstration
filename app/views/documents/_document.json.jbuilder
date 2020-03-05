json.extract! document, :id, :name, :description, :data, :type, :sub_type, :created_at, :updated_at
json.url document_url(document, format: :json)
