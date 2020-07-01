module SettingsHelper

  def company_logo
    Setting.logo
  end

  def company_name
    Setting.get_value('company_name')
  end

end
