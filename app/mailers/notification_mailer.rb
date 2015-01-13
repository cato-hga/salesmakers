class NotificationMailer < ApplicationMailer
  default from: "development@retaildoneright.com"

  def sms_reply(sms_message)
    @sms_message = sms_message
    @last_24_hours = sms_message.from_person.sms_messages.
        where('created_at > ?', Time.now - 1.day)
    mail to: sms_message.to_person.email,
         subject: 'SMS Reply from ' + sms_message.from_person.display_name
  end

  def new_sms_thread(sms_message)
    @sms_message = sms_message
    if sms_message.from_person
      @last_24_hours = sms_message.from_person.sms_messages.
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
    puts emails.join ','
    if sms_message.from_person
      subject = 'New SMS Thread Started by ' + sms_message.from_person.display_name
    else
      subject = 'New SMS Thread Started by ' + sms_message.from_num
    end
    mail to: emails,
         subject: subject
  end
end
