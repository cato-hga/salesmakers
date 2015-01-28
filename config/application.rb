require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Reconnect
  class Application < Rails::Application

    #Postmark email delivery
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { api_key: '20ac5706-f8d6-4a4d-8afc-d5c4bbdbcf44'}


    #Setting javascript engine to regular js
    config.generators do |g|
      g.javascript_engine :js
      g.test_framework false
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    #config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths << Rails.root.join('lib')

    # Rails 5.0-ready for avoiding deprecation warnings
    config.active_record.raise_in_transactional_callbacks = true
  end
end
