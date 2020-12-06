require 'rest-client'
require 'json'
require 'ostruct'

class DudaService
  BASE_URI = 'https://api.duda.co/api'
  SECRET = 'Basic MTllNTk4NTRjNzphVlNCaVlFZUFxWmk=' # TODO: Mover para secretsRails

  # Custom templates
  def self.team_templates
    begin
      response = JSON.parse(RestClient.get("#{BASE_URI}/sites/multiscreen/templates",
                                           {Authorization: SECRET}), symbolize_names: true)
      #team_templates = response.take(10)
      response = response.select { |h| h[:template_name].downcase == 'TEMPLATE-MADEIRA'.downcase || h[:template_name].downcase == 'TEMPLATE-COLORFULL'.downcase }
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
                                                "template_id": 1000772,
                                                "default_domain_prefix": "sub-domain",
                                                "lang": "en",
                                                "site_data": {
                                                    "site_domain": "www.kleber.com",
                                                    "external_uid": "kleber",
                                                    "site_business_info": {
                                                        "business_name": "kleber",
                                                        "phone_number": "666666666",
                                                        "email": "klebersubcontas@gmail.com",
                                                        "address": {
                                                            "country": "US",
                                                            "city": "San Francisco",
                                                            "state": "CA",
                                                            "street": "1 Market Street",
                                                            "zip_code": "94111"
                                                        }
                                                    },
                                                    "site_alternate_domains": {
                                                        "domains": ["www.domain1.com", "www.domain1.net", "www.domain2.com"],
                                                        "is_redirect": true
                                                    },
                                                    "site_seo": {
                                                        "og_image": "https://irp-cdn.multiscreensite.com/38e420a5/dms3rep/multi/46090973_1947701631975735_1914562907203436544_n.jpg",
                                                        "title": "Kleber site seo",
                                                        "description": "Example description. Should be around 155 characters long, but can be upto 320."
                                                    }
                                                }
                                            }, {Authorization: SECRET}), symbolize_names: true)
    rescue
      response = nil
    end

    return response
  end

end