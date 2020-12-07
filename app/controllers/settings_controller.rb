class SettingsController < ApplicationController
  load_and_authorize_resource except: [:company_logo, :cached_logo, :company_banner]
  before_action :set_setting, only: [:show, :edit, :update, :destroy]
  before_action :get_logo, only: :company_logo
  require './app/services/duda_service'

  # GET /settings
  def index
    @q = Setting.all.ransack(params[:q])
    @settings = @q.result.page(params[:page])
  end

  def new_site
    site_details = DudaService.get_site(Setting.get_value('site_name'))

    if site_details
      redirect_to site_details[:preview_site_url]
    else
      @templates = DudaService.team_templates unless Setting.get_value('site_name')
    end
  end

  def create_site
    result = DudaService.create_site params[:template_id]

    if result
      s = Setting.find_or_initialize_by(namespace: "site_name")
      s.value = {"value": result[:site_name]}
      s.save

      redirect_to edit_site_settings_path(site_name: result[:site_name])
    end
  end

  def edit_site
    @site_content_library = {
        "location_data": {
            "phones": [
                {
                    "phoneNumber": Setting.get_value('company_phone') || '',
                    "label": "Main"
                }
            ],
            "emails": [
                {
                    "emailAddress": Setting.get_value('company_email') || '',
                    "label": "Main"
                }
            ],
            "label": Setting.get_value('company_address') || '',
            "social_accounts": {
                "facebook": ""
            },
            "address": {
                "countryCode": Setting.get_value('company_address') || ''
            },
            "address_geolocation": Setting.get_value('company_address') || '',
            "logo_url": Setting.get_value('logo') || nil
        },
        "additional_locations": [],
        "site_texts": {
            "overview": "Visão Geral da Empresa",
            "services": "Serviços Oferecidos",
            "custom": [
                {
                    "label": "since",
                    "text": "Since 2003"
                }
            ],
            "about_us": "Produzindo pneus de qualidade a mais de 15 anos"
        },
        "business_data": {
            "name": Setting.get_value('company_name') || nil,
            "logo_url": Setting.get_value('logo') || nil,
            "data_controller": nil
        }
    }
  end

  def update_site
    site_details = DudaService.get_site(params[:site_name])

    if site_details
      # Dates
      site_data = {
          "location_data": {
              "phones": [
                  {
                      "phoneNumber": "+1-202-555-0138",
                      "label": "Main"
                  }
              ],
              "emails": [
                  {
                      "emailAddress": "mail1@gmail.com",
                      "label": ""
                  }
              ],
              "label": "Palmas1",
              "social_accounts": {
                  "facebook": "kleber1"
              },
              "address": {
                  "countryCode": "BRA"
              },
              "address_geolocation": "Palmas, Tocantins, Brasil",
              "geo": {
                  "longitude": "-48.3312",
                  "latitude": "-10.21242"
              },
              "logo_url": nil
          },
          "additional_locations": [],
          "site_texts": {
              "overview": "<p class=\"rteBlock\">Visão Geral da Empresa</p>",
              "services": "<p class=\"rteBlock\">Serviços Oferecidos</p>",
              "custom": [
                  {
                      "label": "since",
                      "text": "Desde 1998 (1)"
                  }
              ],
              "about_us": "Produzindo pneus de qualidade a mais de 15 anos"
          },
          "business_data": {
              "name": "kleber1",
              "logo_url": nil,
              "data_controller": nil
          }
      }

      # Update site
      DudaService.update_content_library(site_details[:site_name], site_data)

      # Publish

      redirect_to site_details[:preview_site_url]
    end
  end

  def email

  end

  def estimate
    #{
    #    "location_data": {
    #        "phones": [
    #            {
    #                "phoneNumber": "123-123-1234",
    #                "label": "Russ Phone"
    #            },
    #            {
    #                "phoneNumber": "18001234567",
    #                "label": "Duda Phone"
    #            }
    #        ],
    #        "emails": [
    #            {
    #                "emailAddress": "api@duda.co",
    #                "label": "API Email"
    #            },
    #            {
    #                "emailAddress": "support@duda.co",
    #                "label": "Support Email"
    #            }
    #        ],
    #        "label": "Duda HQ",
    #        "social_accounts": {
    #            "tripadvisor": "Restaurant_Review-g32849-d2394400-Reviews-Oren_s_Hummus_Shop-Palo_Alto_California.html",
    #            "youtube": "UCPMwzOc1Su-s2z-J1xiU9ig",
    #            "facebook": "duda",
    #            "yelp": "orens-hummus-shop-palo-alto",
    #            "pinterest": "michelleobama",
    #            "google_plus": "+Dudamobile577",
    #            "linkedin": "duda",
    #            "instagram": "orenshummus",
    #            "snapchat": "michelleobama",
    #            "twitter": "dudamobile",
    #            "rss": "https://www.duda.co/blog/feed/",
    #            "vimeo": "dudamobile",
    #            "reddit": "duda"
    #        },
    #        "address": {
    #            "streetAddress": "577 College Ave",
    #            "postalCode": "94306",
    #            "region":"CA",
    #            "city": "Palo Alto",
    #            "country": "US"
    #        },
    #        "address_geolocation": "1833 Harvard St NW, Washington, DC 20009, USA",
    #        "geo": {
    #            "longitude": "-122.4757527166",
    #            "latitude": "37.502439189002"
    #        },
    #        "logo_url": "https://du-cdn.multiscreensite.com/duda_website/img/home/agencies.svg",
    #        "business_hours": [
    #            {
    #                "days": [
    #                    "SAT",
    #                    "SUN"
    #                ],
    #                "open": "00:00",
    #                "close": "00:00"
    #            },
    #            {
    #                "days": [
    #                    "MON",
    #                    "TUE",
    #                    "WED",
    #                    "THU",
    #                    "FRI"
    #                ],
    #                "open": "09:00",
    #                "close": "18:00"
    #            }
    #        ]
    #    },
    #    "additional_locations": [
    #        {
    #            "uuid": "276169839",
    #            "phones": [
    #                {
    #                    "phoneNumber": "123-123-1234",
    #                    "label": ""
    #                }
    #            ],
    #            "emails": [],
    #            "label": "Duda Tel Aviv",
    #            "social_accounts": {},
    #            "address": {},
    #            "geo": {
    #                "longitude": "34.78337",
    #                "latitude": "32.07605"
    #            },
    #            "logo_url": null,
    #            "business_hours": null
    #        }
    #    ],
    #    "site_texts": {
    #        "overview": "Oh, Duda? Duda is a variation of \"Dude\", who just happens to be the main character in one of our favorite movies of all time: The Big Lebowski. You should watch it some time. Look out for that ferret!",
    #        "services": "- Responsive Website Builder",
    #        "custom": [
    #            {
    #                "label": "Example CTA 1",
    #                "text": "THE WEB DESIGN PLATFORM FOR Scaling Your Agency"
    #            },
    #            {
    #                "label": "Example CTA 2",
    #                "text": "THE WEB DESIGN PLATFORM FOR\nBuilding Websites Faster"
    #            }
    #        ],
    #        "about_us": "Duda is a leading website builder for web professionals and agencies of all sizes. Our website builder enables you to build amazing, feature-rich websites that are perfectly suited to desktop, tablet and mobile. Our mobile builder enables you to build mobile-only sites from scratch, or based on an existing desktop site or Facebook business page. Duda allows professionals and agencies to build high-converting, personalized websites at scale. Duda optimizes each and every site for Google PageSpeed."
    #    },
    #    "business_data": {
    #        "name": "Duda",
    #        "logo_url": "https://www.duda.co/developers/REST-API-Reference/images/duda.svg"
    #    },
    #    "site_images": [
    #        {
    #            "label": "Example Store Logo",
    #            "url": "https://irt-cdn.multiscreensite.com/7536fe2010ed4f7ea68e21d0cb868e01/dms3rep/multi/ice_cream_logo_b_w-18-300x300.svg",
    #            "alt": "Example Store Logo"
    #        },
    #        {
    #            "label": "Example Store Banner",
    #            "url": "https://irt-cdn.multiscreensite.com/7536fe2010ed4f7ea68e21d0cb868e01/dms3rep/multi/sign_icecream_shop-1000x1108.jpg",
    #            "alt": "Example Store Banner"
    #        }
    #    ]
    #}
  end

  def atualiza_transactions
    params.reject{|a,b| ["action","commit","controller","redirect","logo"].include? a }.each do |p|
      s = Setting.find_or_initialize_by(namespace: p[0])
      s.value = {"value": p[1] }
      
      s.save
    end

    redirect_to transactions_settings_path, notice: t('notice.setting.updated')
  end

  def atualiza_settings
    params.reject{|a,b| ["action","commit","controller","redirect","logo"].include? a }.each do |p|
      if p[0] != "width" and p[0] != "length" and p[0] != "height" and p[0] != "square_feet"
        s = Setting.find_or_initialize_by(namespace: p[0])
        s.value = {"value": p[1] == "1" ? true : p[1] == "0" ? false : p[1]}
      else
        s = Setting.find_or_initialize_by(namespace: "hidden_measurement_fields")
        if s.value.present?
          s.value["value"]["#{p[0]}"] = p[1] == "1" ? true : false
        else
          s.value = {"value": {}}
          s.value["value"]["#{p[0]}"] = p[1] == "1" ? true : false
        end

      end
      s.save
    end

    if params[:logo].present?
      #binding.pry
      doc = DocumentFile.find_or_initialize_by(origin: "Logo", origin_id: '1e1e3f7b-92f7-4da4-8894-1bfbfb24d39b')
      doc.title = "Logo"
      doc.file = params[:logo]
      doc.save
      s = Setting.find_or_initialize_by(namespace: "logo")
      s.value = {"value": doc.file.url }
      s.save
    end

    if params[:banner].present?
      #binding.pry
      doc = DocumentFile.find_or_initialize_by(origin: "Banner", origin_id: '893d3e36-2542-4fb3-bb70-754ddb97a64b')
      doc.title = "Banner"
      doc.file = params[:banner]
      doc.save

    end
    redirect_to params[:redirect], notice: t('notice.setting.updated')
  end

  def transactions
    @categories = TransactionCategory.all
    @accounts = TransactionAccount.all
  end

  # GET /settings/1
  def show
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  def create
    @setting = Setting.new(setting_params)

    if @setting.save
      redirect_to @setting, notice: t('notice.setting.created')
    else
      render :new
    end
  end

  # PATCH/PUT /settings/1
  def update
    if @setting.update(setting_params)
      redirect_to @setting, notice: t('notice.setting.updated')
    else
      render :edit
    end
  end

  # DELETE /settings/1
  def destroy
    @setting.destroy
    redirect_to settings_url, notice: t('notice.setting.deleted')
  end

  #Render Company Logo
  def company_logo
  end

  def cached_logo
    http_cache_forever(public: true) do
      get_logo
    end
  end

  #Render Company Banner
  def company_banner
    #redirect_to Setting.logo
    s = Setting.banner_object
    data = open(s.file.url)
    send_data data.read, filename: s.file.filename, type: s.file.content_type, disposition: 'inline', stream: 'true', buffer_size: '4096'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def setting_params
      params.require(:setting).permit(:namespace, :value)
    end

  def get_logo
    begin
      s = Setting.logo_object
      data = open(s.file.url)
      send_data data.read, filename: s.file.filename, type: s.file.content_type, disposition: 'inline', stream: 'true', buffer_size: '4096'
    rescue
      send_file 'public/materialize/images/avatar/avatar-7.png', type: 'image/png', disposition: 'inline', stream: 'true', buffer_size: '4096'
    end
  end
end
