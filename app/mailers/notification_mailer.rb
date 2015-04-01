class NotificationMailer < ApplicationMailer
  default from: "development@retaildoneright.com"

  def sms_reply(sms_message)
    @sms_message = sms_message
    @last_24_hours = sms_message.from_person ? sms_message.from_person.communication_log_entries.
        where('created_at > ?', Time.zone.now - 1.day) : nil
    if sms_message.from_candidate
      message_cc = 'candidatesms@salesmakersinc.com'
    else
      message_cc = ''
    end
    mail to: sms_message.to_person.email,
         cc: message_cc,
         subject: 'SMS Reply from ' +
             (sms_message.from_person ? sms_message.from_person.display_name : sms_message.from_candidate.name)
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
    elsif sms_message.from_candidate
      subject = 'New SMS Thread Started by ' + sms_message.from_candidate.name
      message_cc = 'candidatesms@salesmakersinc.com'
    else
      formatted_num = '(' + sms_message.from_num[0..2] +
          ') ' + sms_message.from_num[3..5] + '-' +
          sms_message.from_num[6..9]
      subject = 'New SMS Thread Started by ' + formatted_num
      message_cc = ''
    end
    mail to: emails,
         cc: message_cc,
         subject: subject
  end

  def email_bounceback(bounce)
    return if not bounce or bounce.empty?
    return if bounce[:type] and bounce[:type] != 'HardBounce'
    @email_address = bounce[:email] || return
    @bounced_subject = bounce[:subject] || return
    @candidate = Candidate.find_by email: @email_address
    as = Position.find_by name: 'Advocate Supervisor'
    ad = Position.find_by name: 'Advocate Director'
    recipients = []
    recipients << as.people.map { |p| p.email } if as
    recipients << ad.people.map { |p| p.email } if ad
    recruiter = nil
    recruiter = @candidate.person.email if @candidate and @candidate.person
    recipients << recruiter
    recipients = recipients.flatten.compact.uniq || return
    mail to: recipients,
         from: 'notifications@salesmakersinc.com',
         subject: 'Email Bounceback'
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
