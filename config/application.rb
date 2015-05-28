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
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app/contexts')

    # Rails 5.0-ready for avoiding deprecation warnings
    config.active_record.raise_in_transactional_callbacks = true

    config.active_job.queue_adapter = :sidekiq
  end
end

class Time
  def remove_eastern_offset
    self -
        ActiveSupport::TimeZone['Eastern Time (US & Canada)'].utc_offset
  end

  def apply_eastern_offset
    self +
        ActiveSupport::TimeZone['Eastern Time (US & Canada)'].utc_offset
  end

  def apply_pacific_offset
    self +
        ActiveSupport::TimeZone['Pacific Time (US & Canada)'].utc_offset
  end
end

class String
  def nan?
    self !~ /^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/
  end
end

::UnitedStates = Array["AK", "AL", "AR", "AS", "AZ", "CA", "CO",
                       "CT", "DC", "DE", "FL", "GA", "GU", "HI",
                       "IA", "ID", "IL", "IN", "KS", "KY", "LA",
                       "MA", "MD", "ME", "MI", "MN", "MO", "MS",
                       "MT", "NC", "ND", "NE", "NH", "NJ", "NM",
                       "NV", "NY", "OH", "OK", "OR", "PA", "PR",
                       "RI", "SC", "SD", "TN", "TX", "UT", "VA",
                       "VI", "VT", "WA", "WI", "WV", "WY"]