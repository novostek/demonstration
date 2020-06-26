class ApplicationController < ActionController::Base
  before_action :cache_globals_settings
  before_action :api_authenticator, if: :format_js?
  before_action :authenticate_user!, except: [:company_banner,:company_logo,:oauth,:doc_signature_mail,:doc_signature,:estimate_signature, :create_products_estimates, :process_payment, :create_step_one, :create_schedule, :delete_schedule, :callback, :calculate_product_qty_lw,:view_invoice_customer,:send_square]
  load_and_authorize_resource except: [:doc_signature_mail,:doc_signature,:estimate_signature, :create_products_estimates, :process_payment, :create_step_one, :create_schedule, :delete_schedule, :callback, :calculate_product_qty_lw,:view_invoice_customer,:send_square]

  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?

  add_breadcrumb I18n.t("breadcrumbs.home"), :root_path
  before_action :set_default_breadcrumbs, only: [:index, :show, :edit, :new]

  def toastr(type, body)
    flash["#{type}"] = body
  end

  def api_authenticator
    if params[:access_token].present?
      token = UserToken.find_by_id(params[:access_token])
      if token.present? and token.active
        sign_in(token.user)
      end
    end
  end


  def cache_globals_settings
    @company_name = Setting.get_value('company_name')
    @last_logo_update = Setting.logo_object.present? ? Setting.logo_object.updated_at.to_i : 0
  end

  def set_smtp
    smtp_settings = {
        :address => Setting.get_value("mail_address"), :port => Setting.get_value("mail_port").to_i,
        :domain => Setting.url,
        :authentication => 'plain',
        :user_name => Setting.get_value("mail_user"),
        :password => Setting.get_value("mail_password"),
        :enable_starttls_auto => true
    }
    #binding.pry
    #mail.delivery_method.settings.merge!(smtp_settings)
  end

  def set_default_breadcrumbs
    add_breadcrumb I18n.t("activerecord.models.#{params[:controller]}"), "/#{params[:controller]}"
    if params[:action] != "index"
      if params[:action] == "show"
        link = "/#{params[:controller]}/#{params[:id]}"
      elsif params[:action] == "new"
        link = "/#{params[:controller]}/new"
      else
        link = "/#{params[:controller]}/#{params[:id]}/#{params[:action]}"
      end
      add_breadcrumb I18n.t("breadcrumbs.#{params[:action]}"), link
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:email,:worker_id])
  end

  private
  def format_js?
    request.format.symbol == :json
  end
end
