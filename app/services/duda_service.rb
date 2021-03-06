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
                                           { Authorization: SECRET }), symbolize_names: true)
      #team_templates = response.take(10)
      response = response.select { |h| h[:template_name].downcase == 'MADEIRA-V3'.downcase || h[:template_name].downcase == 'STANDARDT-V3'.downcase }
    rescue
      response = nil
    end

    return response
  end

  # Create site
  def self.create_site(template_id)
    site_data = {
      "template_id": template_id.to_i,
      "default_domain_prefix": "#{Apartment::Tenant.current}",
      "lang": "en",
      "site_data": {
        "site_domain": "www.#{Apartment::Tenant.current}.com",
        "site_business_info": {
          "business_name": "#{Setting.get_value('company_name')}",
          "phone_number": "#{Setting.get_value('company_phone')}",
          "email": "#{Setting.get_value('company_email')}",
        }
      }
    }

    error = false
    response = nil
    begin
      response = RestClient.post("#{BASE_URI}/sites/multiscreen/create",
                                 site_data.to_json, { content_type: :json, authorization: SECRET })
    rescue => e
      error = e.response
    end

    if error.present? and error.code == 400
        site_data[:site_data][:site_domain] = nil

        begin
          response = RestClient.post("#{BASE_URI}/sites/multiscreen/create",
                                     site_data.to_json, { content_type: :json, authorization: SECRET })
        rescue
        end
    end

    response_json = false
    if response.present?
      if response.code == 200
        response_json = JSON.parse(response, symbolize_names: true)
      end
    end

    return response_json
  end

  # Get content site
  def self.get_content_library(site_name)

    begin
      response = JSON.parse(RestClient.get("#{BASE_URI}/sites/multiscreen/#{site_name}/content",
                                           { content_type: :json, authorization: SECRET }), symbolize_names: true)
    rescue => error
      response = nil
    end

    response
  end

  # Update content site
  def self.update_content_library(site_name, site_data)

    begin
      response = JSON.parse(RestClient.post("#{BASE_URI}/sites/multiscreen/#{site_name}/content",
                                            site_data.to_json, { content_type: :json, authorization: SECRET }), symbolize_names: true)
    rescue => error
      response = nil
    end

    response
  end

  def self.get_site(site_name)
    begin
      response = JSON.parse(RestClient.get("#{BASE_URI}/sites/multiscreen/#{site_name}",
                                           { authorization: SECRET }), symbolize_names: true)
    rescue => error
      response = nil
    end

    response
  end

  def self.publish(site_name)
    begin
      response = JSON.parse(RestClient.post("#{BASE_URI}/sites/multiscreen/publish/#{site_name}",
                                            nil, { content_type: :json, authorization: SECRET }), symbolize_names: true)
    rescue => error
      response = nil
    end

    response
  end

  def self.unpublish(site_name)
    begin
      response = JSON.parse(RestClient.post("#{BASE_URI}/sites/multiscreen/publish/#{site_name}",
                                            nil, { content_type: :json, authorization: SECRET }), symbolize_names: true)
    rescue => error
      response = nil
    end

    response
  end

  def self.delete(site_name)
    begin
      response = JSON.parse(RestClient.delete("#{BASE_URI}/sites/multiscreen/#{site_name}",
                                              { content_type: :json, authorization: SECRET }), symbolize_names: true)
    rescue => error
      response = nil
    end

    response
  end

  def self.create_account(account_data)
    begin
      response = RestClient.post("#{BASE_URI}/accounts/create", account_data.to_json, { content_type: :json, authorization: SECRET })

      if response.code == 204
        result = true
      else
        result = false
      end
    rescue
      result = false
    end

    result
  end

  def self.grant_site_access(account_name, site_name, site_permissions)
    begin
      response = RestClient.post("#{BASE_URI}/accounts/#{account_name}/sites/#{site_name}/permissions",
                                 site_permissions.to_json, { content_type: :json, authorization: SECRET })
      if response.code == 204
        result = true
      else
        result = false
      end
    rescue => error
      result = false
    end

    result
  end

  # Is not working ***
  def self.get_sso_link(account_name)
    begin
      response = JSON.parse(RestClient.get("#{BASE_URI}/accounts/sso/#{account_name}/link",
                                           { content_type: :json, authorization: SECRET }), symbolize_names: true)
    rescue => error
      response = nil
    end

    response
  end

  # ***

  def self.reset_password_link(account_name)
    begin
      response = JSON.parse(RestClient.post("#{BASE_URI}/accounts/reset-password/#{account_name}",
                                            nil, { content_type: :json, authorization: SECRET }), symbolize_names: true)
    rescue
      response = nil
    end

    response
  end

  def self.upload_resource(site_name, img_links)
    resources = []

    img_links.each do |img_link|
      resources << {
        "resource_type": "IMAGE",
        "src": img_link
      }
    end

    begin
      response = RestClient.post("#{BASE_URI}/sites/multiscreen/resources/#{site_name}/upload",
                                 resources.to_json, { content_type: :json, authorization: SECRET })
      if response.code == 200
        result = true
      else
        result = false
      end
    rescue
      result = false
    end

    if result
      response_json = JSON.parse(response, symbolize_names: true)
    else
      response_json = {}
    end

    return result, response_json
  end

end