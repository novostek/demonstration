json.extract! note, :id, :title, :text, :private, :origin, :origin_id, :created_at, :updated_at
json.url note_url(note, format: :json)
