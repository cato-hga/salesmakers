class EmailBouncebackNotifierJob < ActiveJob::Base
  queue_as :default

  def perform(minutes)
    after_datetime = DateTime.now - minutes.minutes
    client = Postmark::ApiClient.new Postmark.api_token
    bounces = client.bounces.first(minutes * 4)
    for bounce in bounces do
      if bounce[:bounced_at] and bounce[:bounced_at].to_datetime >= after_datetime
        NotificationMailer.email_bounceback(bounce).deliver_now
      end
    end
  end
end