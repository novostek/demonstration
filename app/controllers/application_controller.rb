class ApplicationController < ActionController::Base
  before_action :cache_globals_settings
  before_action :authenticate_user!, except: [:create_products_estimates, :process_payment, :create_step_one, :create_schedule, :delete_schedule, :callback, :calculate_product_qty_lw]

  skip_before_action :verify_authenticity_token
  # before_action :authenticate_user!


  before_action :configure_permitted_parameters, if: :devise_controller?



  def cache_globals_settings
    @company_name = Setting.get_value('company_name')
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:email])
  end
end
