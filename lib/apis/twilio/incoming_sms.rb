module Twilio
  module IncomingSMS
    def handle_sms(from, to, message, sid)
      info = get_info(from)
      incoming_message = SMSMessage.new from_num: unformat_number(from),
                                        to_num: unformat_number(to),
                                        from_person_id: info[:from][:person_id],
                                        from_candidate_id: info[:from][:candidate_id],
                                        to_person_id: info[:to][:person_id],
                                        inbound: true,
                                        reply_to_sms_message_id: (info[:reply_to_message] ? info[:reply_to_message].id : nil),
                                        message: message,
                                        sid: sid
      if incoming_message.save
        log_message_info(info, incoming_message, message)
        send_notification(info, incoming_message)
      end
    end

    private

    def get_info(formatted_from_number)
      from_info = get_from(formatted_from_number)
      reply_to_message = lookup_reply_to_object from_info[:person]
      reply_to_message = lookup_reply_to_object from_info[:candidate] unless reply_to_message
      to_info = get_to(reply_to_message)
      {
          from: from_info,
          to: to_info,
          reply_to_message: reply_to_message
      }
    end

    def lookup_reply_to_object(object)
      return nil unless object
      administrator = Person.find_by display_name: 'System Administrator'
      administrator_id = administrator ? administrator.id : 0
      messages = SMSMessage.where(
          'created_at > ? AND to_' + object.class.name.underscore + '_id = ? AND NOT from_person_id = ?',
          Time.zone.now - 1.day,
          object.id,
          administrator_id
      ).order(created_at: :desc).limit(1)
      messages.count > 0 ? messages.first : nil
    end

    def get_from(formatted_from_number)
      from_number = unformat_number formatted_from_number
      from_person = lookup_object_by_number Person, from_number
      from_candidate = lookup_object_by_number Candidate, from_number
      from_person_id = from_person ? from_person.id : nil
      from_candidate_id = from_candidate ? from_candidate.id : nil
      {
          person: from_person,
          person_id: from_person_id,
          candidate: from_candidate,
          candidate_id: from_candidate_id
      }
    end

    def get_to(reply_to_message)
      to_person = reply_to_message ? reply_to_message.from_person : nil
      to_person_id = to_person ? to_person.id : nil
      {
          person: to_person,
          person_id: to_person_id
      }
    end

    def log_message_info(info, incoming_message, message)
      if info[:from][:person]
        info[:from][:person].log? 'receive_sms',
                                  incoming_message,
                                  info[:to][:person],
                                  nil,
                                  nil,
                                  message
      end
      if info[:from][:candidate]
        recruiter = info[:to][:person]
        recruiter = info[:from][:candidate].created_by unless recruiter
        CandidateContact.create candidate: info[:from][:candidate],
                                contact_method: :sms,
                                inbound: true,
                                person: recruiter,
                                notes: message
      end
    end

    def send_notification(info, incoming_message)
      if info[:reply_to_message]
        info[:reply_to_message].update replied_to: true
        NotificationMailer.sms_reply(incoming_message).deliver_later
      else
        NotificationMailer.new_sms_thread(incoming_message).deliver_later
      end
    end
  end
end