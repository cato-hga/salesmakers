class NotificationMailer < ApplicationMailer
  default from: "development@retaildoneright.com"

  def sms_reply(sms_message)
    set_sms_variables(sms_message)
    handle_send to: sms_message.to_person.email,
                cc: (sms_message.from_candidate ? 'candidatesms@salesmakersinc.com' : ''),
                subject: 'SMS Reply from ' +
                    (sms_message.from_person ? sms_message.from_person.display_name : sms_message.from_candidate.name)
  end

  def new_sms_thread(sms_message)
    set_sms_variables(sms_message)
    emails = get_emails_for_sms_message(sms_message)
    return if emails.empty?
    subject = get_subject_from_sms_message(sms_message)
    handle_send to: emails,
                cc: (sms_message.from_candidate ? 'candidatesms@salesmakersinc.com' : ''),
                subject: subject
  end

  def email_bounceback(bounce)
    return if not bounce or bounce.empty?
    return if bounce[:type] and bounce[:type] != 'HardBounce'
    @email_address = bounce[:email] || return
    @bounced_subject = bounce[:subject] || return
    @candidate = Candidate.find_by email: @email_address
    recipients = get_emails_for_bouncebacks || return
    handle_send to: recipients,
                from: 'notifications@salesmakersinc.com',
                subject: 'Email Bounceback'
  end

  def vonage_hours_with_no_location
    emails = get_developer_emails || return
    emails.concat [
                      'jumartinez@retaildoneright.com',
                      'nhissa@retaildoneright.com',
                      'tspurlock@retaildoneright.com',
                      'dvoorhees@retaildoneright.com',
                      'rcushing@retaildoneright.com'
                  ]
    @timesheets = ConnectTimesheet.
        where("shift_date = ? AND rc_timesheet.c_bpartner_location_id IS NULL", Date.yesterday).
        joins(:connect_user).
        order("ad_user.name ASC")
    return if @timesheets.empty?
    handle_send to: emails,
                subject: 'Vonage Hours with No Location Attached'
  end

  def simple_mail(to_emails, subject, content, html = false, attachment_array = nil)
    content_type = 'text/plain'
    content_type = 'text/html' if html
    if attachment_array && !attachment_array.empty?
      for attachment in attachment_array do
        attachments[File.basename(attachment)] = File.read(attachment)
      end
    end
    handle_send to: to_emails,
                subject: subject,
                body: content,
                content_type: content_type
  end

  private

  def set_sms_variables(sms_message)
    @sms_message = sms_message
    @last_24_hours = sms_message.from_person ? sms_message.from_person.communication_log_entries.
        where('created_at > ?', Time.zone.now - 1.day) : nil
  end

  def get_emails_for_sms_message(sms_message)
    emails = Array.new
    if @sms_message.to_num.include? '7277776336'
      emails << 'hr@retaildoneright.com'
    else
      positions = Position.where twilio_number: '+1' + @sms_message.to_num
      return emails if positions.empty?
      people = Person.where position: positions
      return emails if people.empty?
      people.each { |p| emails << p.email }
    end
    emails
  end

  def get_subject_from_sms_message(sms_message)
    if @sms_message.from_person
      'New SMS Thread Started by ' + @sms_message.from_person.display_name
    elsif @sms_message.from_candidate
      'New SMS Thread Started by ' + @sms_message.from_candidate.name
    else
      formatted_num = '(' + @sms_message.from_num[0..2] +
          ') ' + @sms_message.from_num[3..5] + '-' +
          @sms_message.from_num[6..9]
      'New SMS Thread Started by ' + formatted_num
    end
  end

  def get_emails_for_bouncebacks
    as = Position.find_by name: 'Advocate Supervisor'
    ad = Position.find_by name: 'Advocate Director'
    recipients = []
    recipients << as.people.map { |p| p.email } if as
    recipients << ad.people.map { |p| p.email } if ad
    recruiter = nil
    recruiter = @candidate.person.email if @candidate and @candidate.person
    recipients << recruiter
    recipients.flatten.compact.uniq
  end
end
