class ConfirmJob < ApplicationJob
  queue_as :default

  def perform(code, job)
    # Do something later
    if Rails.env.production?
      url = ""
    else
      url = "http://localhost:3001/clients/get_client?code=#{code}"
    end
    data = JSON.parse(RestClient.get url)

    if data.present?
      client = Client.new
      client.name = data["company_name"]
      client.company_name = data["company_name"]
      client.email = data["email"]
      client.tenant_name = data["domain"]
      client.code = data["code"]
      client.pwd = data["password"]
      if client.save
        job.complete = true
        #if !Rails.env.production?
          job.redirect = "http://#{client.tenant_name}.woffice.biz"
        #else
        #job.redirect = "http://#{client.domain}.lvh.me:3000"
        #end
        job.save
      end
    end
  end
end
