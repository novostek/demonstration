require_relative 'boot'

require 'rails/all'
require 'apartment/elevators/subdomain' # or 'domain', 'first_subdomain', 'host'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Woffice
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.action_controller.default_protect_from_forgery = true
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :'en'

    config.time_zone = 'Eastern Time (US & Canada)'
    Time::DATE_FORMATS[:default] = "%m/%d/%Y %I:%M %p"
    Date::DATE_FORMATS[:default] = "%m/%d/%Y"

    #libera acesso as hosts
    config.hosts.clear
    config.woffice = config_for(:woffice_config)

    #apartment
    config.middleware.use Apartment::Elevators::Subdomain


  end
end
