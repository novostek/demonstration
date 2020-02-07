json.extract! document_file, :id, :title, :file, :origin, :origin_id, :esign, :esign_data, :photo, :photo_date, :photo_description, :created_at, :updated_at
json.url document_file_url(document_file, format: :json)
