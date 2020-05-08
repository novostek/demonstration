json.extract! profile, :id, :name, :description, :permissions, :status, :created_at, :updated_at
json.url profile_url(profile, format: :json)
