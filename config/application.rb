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

    # if ENV['RAILS_ENV'] == 'production'
    config.to_prepare do
      Devise::SessionsController.skip_before_action :startup_bot
      Devise::SessionsController.skip_before_action :verify_welcome
    end
    # end
      #config.middleware.use
    if ENV['RAILS_ENV'] == 'production'
      Raven.configure do |config|
        config.dsn = 'https://ac044efa7c4749e0b30c6922fb1d64d8:10139fb5f6fd4be6b04e7df9b8eda104@o418477.ingest.sentry.io/5321448'
      end
    end
  end
end
