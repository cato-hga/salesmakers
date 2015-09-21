class EmailBouncebackNotifierJob < ActiveJob::Base
  queue_as :default

  def perform minutes, automated = false
    begin
      RunningProcess.running! self
      after_datetime = DateTime.now - minutes.minutes
      client = Postmark::ApiClient.new Postmark.api_token
      attempts = 1
      begin
        bounces = client.bounces.first(minutes * 4)
        for bounce in bounces do
          if bounce[:bounced_at] and bounce[:bounced_at].to_datetime >= after_datetime
            NotificationMailer.email_bounceback(bounce).deliver_now
          end
        end
      rescue Postmark::TimeoutError => ex
        Rails.logger.error "Error: #{ex}"
        sleep 5
        retry if (attempts += 1) <= 3
      end
      SlackJobNotifier.ping "[EmailBouncebackNotifierJob] Reported #{bounces.count.to_s} bounced email addresses." if bounces.count > 0
      ProcessLog.create process_class: "EmailBouncebackNotifierJob", records_processed: bounces.count if automated
    ensure
      RunningProcess.shutdown! self
    end
  end

end