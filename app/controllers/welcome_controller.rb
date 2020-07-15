class WelcomeController < ApplicationController
  before_action :verify_welcome

  layout 'welcome'

  def index
    welcome = Setting.find_or_initialize_by(namespace: 'welcome')
    welcome.value = {"value": true}
    welcome.save
  end

  private

  def verify_welcome
    redirect_to finance_dashboard_path if Setting.get_value('welcome')
  end

end