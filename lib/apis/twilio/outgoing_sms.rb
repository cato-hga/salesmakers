module Twilio
  module OutgoingSMS
    def send_text(number, text)
      formatted_number = format_number number
      @client.account.messages.create to: formatted_number,
                                      from: @from,
                                      body: text
    end

    def send_text_to_person(person, text, sender)
      phone = person.mobile_phone
      return nil unless phone
      formatted_number = format_number phone
      response = @client.account.messages.create to: formatted_number,
                                                 from: @from,
                                                 body: text

      message = record_outgoing_message @from, sender, phone, person, text, response

      if message.save
        sender.log? 'send_sms', person, message, nil, nil, text
      end
      response
    end

    def send_text_to_candidate(candidate, text, sender)
      phone = candidate.mobile_phone
      return nil unless phone
      formatted_number = format_number phone
      response = @client.account.messages.create to: formatted_number,
                                                 from: @from,
                                                 body: text

      message = record_outgoing_message @from, sender, phone, candidate, text, response

      if message.save
        sender.log? 'send_sms', candidate, message, nil, nil, text
        CandidateContact.create candidate: candidate,
                                contact_method: :sms,
                                person: sender,
                                notes: text

      end
      response
    end

    private

    def record_outgoing_message(from, sender, phone, from_obj, text, response)
      msg = SMSMessage.new from_num: unformat_number(from),
                           from_person_id: sender.id,
                           to_num: unformat_number(phone),
                           message: text,
                           sid: response.sid
      if from_obj.is_a?(Person)
        msg.to_person_id = from_obj.id
      elsif from_obj.is_a?(Candidate)
        msg.to_candidate_id = from_obj.id
      end
      msg
    end
  end
end