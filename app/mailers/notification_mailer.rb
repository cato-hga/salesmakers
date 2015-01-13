class NotificationMailer < ApplicationMailer
  default from: "development@retaildoneright.com"

  def sms_reply(sms_message)
    @sms_message = sms_message
    @last_24_hours = sms_message.from_person.sms_messages.
        where('created_at > ?', Time.now - 1.day)
    mail to: sms_message.to_person.email,
         subject: 'SMS Reply from ' + sms_message.from_person.display_name
  end
end
