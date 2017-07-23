require_relative 'boot'

require 'rails/all'

# TIL FONTS
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SweigApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    I18n.enforce_available_locales = false
    I18n.config.available_locales = :da
    config.i18n.default_locale = :da


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

  end
end
