# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

require 'exception_notification/rails'
require 'sidekiq'

cas_options = {
    cas_base_url: "http://auth.rbdconnect.com/cas/"
}

module ExceptionNotification
  class Sidekiq
    def call(worker, msg, queue)
      begin
        yield
      rescue Exception => exception
        unless exception.is_a?(Postmark::InvalidMessageError) and
            exception.to_s.include?('You tried to send to a recipient that has been marked as inactive')
          ExceptionNotifier.notify_exception(exception, :data => { :sidekiq => msg })
        end
        raise exception
      end
    end
  end
end

if Rails.env.production? or Rails.env == 'staging'
  service_url = "http://newcenter.salesmakersinc.com/" if Rails.env.production?
  service_url = "http://staging.salesmakersinc.com/" if Rails.env == 'staging'
  cas_options = cas_options.merge({ service_url: service_url })

  ::Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      chain.add ::ExceptionNotification::Sidekiq
    end
  end
end

CASClient::Frameworks::Rails::Filter.configure(cas_options)