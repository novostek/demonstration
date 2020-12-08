require 'rest-client'
require 'json'
require 'ostruct'

class DudaService
  BASE_URI = 'https://api.duda.co/api'
  SECRET = "Basic MTllNTk4NTRjNzphVlNCaVlFZUFxWmk=" # TODO: move to secretsRails

  # Get custom templates
  def self.team_templates
    begin
      response = JSON.parse(RestClient.get("#{BASE_URI}/sites/multiscreen/templates",
                                           {Authorization: SECRET}), symbolize_names: true)
      #team_templates = response.take(10)
      response = response.select { |h| h[:template_name].downcase == 'TEMPLATE-MADEIRA'.downcase || h[:template_name].downcase == 'TEMPLATE-COLORFULL'.downcase || h[:template_name].downcase == 'TEMPLATE-MADEIRA-V3'.downcase }
    rescue
      response = nil
    end

    return response
  end

  # Create site
  def self.create_site(template_id)
    begin
      response = JSON.parse(RestClient.post("#{BASE_URI}/sites/multiscreen/create",
                                            {
                                                "template_id": template_id.to_i,
                                                "lang": "en",
                                                "site_data": {
                                                    "site_business_info": {
                                                        "business_name": "#{Setting.get_value('company_name')}",
                                                        "phone_number": "#{Setting.get_value('company_phone')}",
                                                        "email": "#{Setting.get_value('company_email')}",
                                                    }
                                                }
                                            }.to_json, {content_type: :json, authorization: SECRET}), symbolize_names: true)
    rescue
      response = nil
    end

    response
  end

  # Get content site
  def self.get_content_library(site_name)

    begin
      response = JSON.parse(RestClient.get("#{BASE_URI}/sites/multiscreen/#{site_name}/content",
                                           {content_type: :json, authorization: SECRET}), symbolize_names: true)
    rescue => error
      response = nil
    end

    response
  end

  # Update content site
  def self.update_content_library(site_name, site_data)

    begin
      response = JSON.parse(RestClient.post("#{BASE_URI}/sites/multiscreen/#{site_name}/content",
                                            site_data.to_json, {content_type: :json, authorization: SECRET}), symbolize_names: true)
    rescue => error
      response = nil
    end

    response
  end

  def self.get_site(site_name)
    begin
      response = JSON.parse(RestClient.get("#{BASE_URI}/sites/multiscreen/#{site_name}",
                                            {authorization: SECRET}), symbolize_names: true)
    rescue => error
      response = nil
    end

    response
  end

  def self.publish(site_name)
    begin
      response = JSON.parse(RestClient.post("#{BASE_URI}/sites/multiscreen/publish/#{site_name}",
                                            nil, {content_type: :json, authorization: SECRET}), symbolize_names: true)
    rescue => error
      response = nil
    end

    response
  end

  def self.unpublish(site_name)
    begin
      response = JSON.parse(RestClient.post("#{BASE_URI}/sites/multiscreen/publish/#{site_name}",
                                            nil, {content_type: :json, authorization: SECRET}), symbolize_names: true)
    rescue => error
      response = nil
    end

    response
  end

  def self.delete(site_name)
    begin
      response = JSON.parse(RestClient.delete("#{BASE_URI}/sites/multiscreen/#{site_name}",
                                            {content_type: :json, authorization: SECRET}), symbolize_names: true)
    rescue => error
      response = nil
    end

    response
  end

end