class SettingsController < ApplicationController
  load_and_authorize_resource except: [:company_logo, :cached_logo, :company_banner]
  before_action :set_setting, only: [:show, :edit, :update, :destroy]
  before_action :set_site, only: [:show_site, :new_site, :edit_site, :update_site, :unpublish_site, :delete_site]
  before_action :get_logo, only: :company_logo
  require './app/services/duda_service'

  # GET /settings
  def index
    @q = Setting.all.ransack(params[:q])
    @settings = @q.result.page(params[:page])
  end

  def new_site
    if @site
      redirect_to action: :show_site
    else
      @templates = DudaService.team_templates
    end
  end

  def create_site
    site_result = DudaService.create_site(params[:template_id])

    if site_result
      s = Setting.find_or_initialize_by(namespace: "site_name_duda")
      s.value = { "value": site_result[:site_name] }
      s.save

      # # Publish
      # DudaService.publish(site_result[:site_name])

      # Create account
      account_data = {
        account_name: Apartment::Tenant.current,
        account_type: 'CUSTOMER',
        email: Setting.get_value('company_email'),
        first_name: Setting.get_value('company_name'),
        last_name: site_result[:site_name]
      }
      account_result = DudaService.create_account(account_data)

      if account_result
        # Allow change site
        allow_change_site(account_data[:account_name], site_result[:site_name], account_data)
      else
        account_data[:account_name] = "#{Setting.get_value('company_name')}_#{site_result[:site_name]}"
        DudaService.create_account(account_data)

        # Allow change site
        allow_change_site(account_data[:account_name], site_result[:site_name], account_data)
      end

      redirect_to edit_site_settings_path(site_name: site_result[:site_name])
    else
      redirect_to new_site_settings_path, notice: t('notice.setting.an_error_occurred_try_again_more_pie')
    end
  end

  def edit_site
    @site_data = DudaService.get_content_library(params[:site_name])
  end

  def update_site
    if @site
      logo = upload_logo_to_duda(@site[:site_name])

      site_data = {
        "location_data": {
          "phones": [
            {
              "phoneNumber": Setting.get_value('company_phone') || '',
              "label": ""
            }
          ],
          "emails": [
            {
              "emailAddress": Setting.get_value('company_email') || '',
              "label": ""
            }
          ],
          "label": Setting.get_value('company_address') || '',
          "social_accounts": {},
          "address": {
            "countryCode": "EN"
          },
          "address_geolocation": Setting.get_value('company_address') || '',
          "logo_url": logo,
          "business_hours": []
        },
        "additional_locations": [],
        "site_texts": {
          "overview": params[:overview],
          "services": params[:services],
          "custom": [
            {
              "label": "since",
              "text": params[:since]
            },
            {
              "label": "main_text",
              "text": params[:main_text]
            },
            {
              "label": "title_experiency",
              "text": params[:title_experiency]
            },
            {
              "label": "text_experiency",
              "text": params[:text_experiency]
            },
            {
              "label": "title_requeste_cote",
              "text": params[:title_requeste_cote]
            }
          ],
          "about_us": params[:about_us]
        },
        "business_data": {
          "name": Setting.get_value('company_name') || nil,
          "logo_url": logo,
          "data_controller": nil
        },
        "site_images": []
      }

      # Update content site
      DudaService.update_content_library(@site[:site_name], site_data)

      # Publish
      DudaService.publish(@site[:site_name])

      redirect_to action: :show_site, notice: t('texts.settings.publish')
    end
  end

  def show_site
    @account_site_duda = Setting.get_value('account_site_duda')

    link_editor = DudaService.reset_password_link(@account_site_duda['account_name'])
    @link_editor = link_editor[:reset_url] if link_editor
  end

  def unpublish_site
    DudaService.unpublish(@site[:site_name])

    redirect_to action: :show_site, notice: t('texts.settings.unpublish')
  end

  def delete_site
    DudaService.delete(@site[:site_name])

    @site.destroy

    redirect_to action: :show_site, notice: t('texts.settings.site_deleted')
  end

  def email
  end

  def estimate
  end

  def atualiza_transactions
    params.reject { |a, b| ["action", "commit", "controller", "redirect", "logo"].include? a }.each do |p|
      s = Setting.find_or_initialize_by(namespace: p[0])
      s.value = { "value": p[1] }

      s.save
    end

    redirect_to transactions_settings_path, notice: t('notice.setting.updated')
  end

  def atualiza_settings
    params.reject { |a, b| ["action", "commit", "controller", "redirect", "logo"].include? a }.each do |p|
      if p[0] != "width" and p[0] != "length" and p[0] != "height" and p[0] != "square_feet"
        s = Setting.find_or_initialize_by(namespace: p[0])
        s.value = { "value": p[1] == "1" ? true : p[1] == "0" ? false : p[1] }
      else
        s = Setting.find_or_initialize_by(namespace: "hidden_measurement_fields")
        if s.value.present?
          s.value["value"]["#{p[0]}"] = p[1] == "1" ? true : false
        else
          s.value = { "value": {} }
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
      s.value = { "value": doc.file.url }
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

  def set_site
    @site = DudaService.get_site(Setting.get_value('site_name_duda'))
  end

  def allow_change_site(account_name, site_name, account_data)
    site_permissions = { permissions: %w[STATS_TAB EDIT E_COMMERCE PUBLISH REPUBLISH DEV_MODE INSITE SEO BACKUPS CUSTOM_DOMAIN RESET BLOG PUSH_NOTIFICATIONS LIMITED_EDITING CONTENT_LIBRARY] }
    DudaService.grant_site_access(account_name, site_name, site_permissions)

    # Save account_site_duda
    s = Setting.find_or_initialize_by(namespace: "account_site_duda")
    s.value = { "value": account_data }
    s.save
  end

  def upload_logo_to_duda(site_name)
    logo_url = Setting.logo
    logo_new_url = nil

    if logo_url
      result, json = DudaService.upload_resource(site_name, [logo_url])
      if result and json[:uploaded_resources][0][:status] == 'UPLOADED'
        logo_new_url = json[:uploaded_resources][0][:new_url]
      end
    end

    logo_new_url
  end
end
