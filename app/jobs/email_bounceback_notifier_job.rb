class EmailBouncebackNotifierJob < ActiveJob::Base
  queue_as :default

  def perform(minutes)
    after_datetime = DateTime.now - minutes.minutes
    client = Postmark::ApiClient.new Postmark.api_token
    bounces = client.bounces.first(minutes * 4)
    for bounce in bounces do
      if bounce[:bounced_at] and bounce[:bounced_at].to_datetime >= after_datetime
        attempts = 1
        begin
          NotificationMailer.email_bounceback(bounce).deliver_now
        rescue Postmark::TimeoutError => ex
          Rails.logger.error "Error: #{ex}"
          sleep 5
          retry if (attempts += 1) <= 3
        end
      end
    end
    ProcessLog.create process_class: self.class.name, records_processed: bounces.count
  end
end