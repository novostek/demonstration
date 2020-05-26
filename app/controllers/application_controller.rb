class ApplicationController < ActionController::Base
  before_action :cache_globals_settings
  before_action :authenticate_user!, except: [:company_banner,:company_logo,:oauth,:doc_signature_mail,:doc_signature,:estimate_signature, :create_products_estimates, :process_payment, :create_step_one, :create_schedule, :delete_schedule, :callback, :calculate_product_qty_lw,:view_invoice_customer,:send_square]
  #load_and_authorize_resource except: [:doc_signature_mail,:doc_signature,:estimate_signature, :create_products_estimates, :process_payment, :create_step_one, :create_schedule, :delete_schedule, :callback, :calculate_product_qty_lw,:view_invoice_customer,:send_square]

  skip_before_action :verify_authenticity_token
  # before_action :authenticate_user!


  before_action :configure_permitted_parameters, if: :devise_controller?

  def toastr(type, body)
    flash["#{type}"] = body
  end


  def cache_globals_settings
    @company_name = Setting.get_value('company_name')
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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:email,:worker_id])
  end
end
