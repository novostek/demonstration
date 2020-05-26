json.extract! running_job, :id, :complete, :redirect, :created_at, :updated_at
json.url running_job_url(running_job, format: :json)
