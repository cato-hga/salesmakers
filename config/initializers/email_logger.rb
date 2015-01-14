class EmailLoggingObserver
  def self.delivered_email(message)
    plain_part = message.multipart? ? (message.text_part ? message.text_part.body.decoded : nil) : message.body.decoded
    html_part = message.html_part ? message.html_part.body.decoded : nil
    for to_email in message.to do
      EmailMessage.create from_email: message.from[0],
                          to_email: to_email,
                          subject: message.subject,
                          content: html_part ? html_part : plain_part
    end
  end
end

ActionMailer::Base.register_observer(EmailLoggingObserver)