module SettingsHelper

  def company_logo
    Setting.logo
  end

  def company_name
    Setting.find_by(namespace: 'company_name').value['value']
  end

end
