require 'exception_notification/rails'
require 'sidekiq'

class ExceptionNotificationOptions
  def self.hash environment_tag
    {
        email: {
            email_prefix: "[#{environment_tag}] ",
            sender_address: 'development@retaildoneright.com',
            exception_recipients: %w{smiles@retaildoneright.com aatkinson@retaildoneright.com},
            sections: %w{request person session environment backtrace}
        },
        slack: {
            webhook_url: 'https://hooks.slack.com/services/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'
        }
    }
  end
end

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

::Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add ::ExceptionNotification::Sidekiq
  end
end