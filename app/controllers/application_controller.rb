class ApplicationController < ActionController::Base
  before_action :cache_globals_settings

  def cache_globals_settings
    @company_name = Setting.get_value('company_name')
  end
end
