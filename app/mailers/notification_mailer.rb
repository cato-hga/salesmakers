class NotificationMailer < ApplicationMailer
  default from: "development@retaildoneright.com"

  def sms_reply(sms_message)
    @sms_message = sms_message
    @last_24_hours = sms_message.from_person.communication_log_entries.
        where('created_at > ?', Time.zone.now - 1.day)
    mail to: sms_message.to_person.email,
         subject: 'SMS Reply from ' + sms_message.from_person.display_name
  end

  def new_sms_thread(sms_message)
    @sms_message = sms_message
    if sms_message.from_person
      @last_24_hours = sms_message.from_person.communication_log_entries.
          where('created_at > ?', Time.now - 1.day)
    else
      @last_24_hours = nil
    end
    positions = Position.where twilio_number: '+1' + sms_message.to_num
    return if positions.count < 1
    people = Person.where position: positions
    return if people.count < 1
    emails = Array.new
    people.each { |p| emails << p.email }
    return if emails.count < 1
    if sms_message.from_person
      subject = 'New SMS Thread Started by ' + sms_message.from_person.display_name
    else
      formatted_num = '(' + sms_message.from_num[0..2] +
          ') ' + sms_message.from_num[3..5] + '-' +
          sms_message.from_num[6..9]
      subject = 'New SMS Thread Started by ' + formatted_num
    end
    mail to: emails,
         subject: subject
  end

  def simple_mail(to_email, subject, content, html = false)
    content_type = 'text/plain'
    content_type = 'text/html' if html
    mail to: to_email,
         subject: subject,
         body: content,
         content_type: content_type
  end
end
