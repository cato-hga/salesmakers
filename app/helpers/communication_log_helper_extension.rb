module CommunicationLogHelperExtension
  def communication_log_from(entry)
    if entry.loggable_type == 'SMSMessage'
      sms_communication_log_from(entry)
    elsif entry.loggable_type == 'EmailMessage'
      email_communication_log_from(entry)
    end
  end

  def sms_communication_log_from(entry)
    message = entry.loggable
    if message.from_person
      person_link message.from_person
    elsif message.from_candidate
      candidate_link message.from_candidate
    else
      phone_link message.from_num
    end
  end

  def email_communication_log_from(entry)
    email = entry.loggable
    email_link email.from_email
  end

  def communication_log_to(entry)
    if entry.loggable_type == 'SMSMessage'
      sms_communication_log_to(entry)
    elsif entry.loggable_type == 'EmailMessage'
      email_communication_log_to(entry)
    end
  end

  def sms_communication_log_to(entry)
    message = entry.loggable
    if message.to_person
      person_link message.to_person
    elsif message.to_candidate
      candidate_link message.to_candidate
    else
      phone_link message.to_num
    end
  end

  def email_communication_log_to(entry)
    email = entry.loggable
    if email.to_person
      person_link email.to_person
    else
      email_link email.to_email
    end
  end

  def communication_log_display(entry)
    if entry.loggable_type == 'SMSMessage'
      sms_communication_log_display(entry)
    elsif entry.loggable_type == 'EmailMessage'
      email_communication_log_display(entry)
    end
  end

  def sms_communication_log_display(entry)
    content_tag :span, entry.loggable.message, class: [:comment]
  end

  def email_communication_log_display(entry)
    'Email: '.html_safe + content_tag(:span, entry.loggable.subject, class: [:comment])
  end
end