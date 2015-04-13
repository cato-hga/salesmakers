require 'twilio-ruby'
require 'open-uri'

class Gateway
  include ActionView::Helpers::TextHelper

  def initialize(from = '+17272286225')
    @from = from
    @message_twimlet_base = 'http://twimlets.com/message?'
    @client = Twilio::REST::Client.new 'AC96a051482517673481ee177d64d52bcf',
                                       '806dd03205d48972b9837da98ccf0348'
  end

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

  def call_with_message(number, text)
    formatted_number = format_number number
    encoded_text = URI::encode text
    url = @message_twimlet_base
    url = url + 'Message%5B0%5D='
    url = url + encoded_text
    url = url + '&'
    @client.account.calls.create to: formatted_number,
                                 from: @from,
                                 url: url,
                                 'IfMachine' => 'hangup'
  end

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

  def handle_call(calling_number)
    calling_number = unformat_number calling_number
    person = lookup_object_by_number Person, calling_number
    Twilio::TwiML::Response.new do |r|
      if person
        announce_sales r, person
      else
        no_records_found r
      end
      r.Say 'Thank You. Goodbye.'
    end
  end

  private

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

  def format_number(number)
    formatted_number = number.strip.gsub /[^0-9]/, ''
    if formatted_number.length == 10
      formatted_number = '+1' + formatted_number
    elsif formatted_number.length == 11 and
        formatted_number[0] == '1'
      formatted_number = '+' + formatted_number
    end
    formatted_number
  end

  def unformat_number(number)
    unformatted_number = number.sub '+1', ''
    unformatted_number.strip.gsub /[^0-9]/, ''
  end

  def lookup_object_by_number(klass, number)
    results = klass.where mobile_phone: number
    results = klass.where office_phone: number unless results.count > 0 if klass.name == 'Person'
    results = klass.where home_phone: number unless results.count > 0 if klass.name == 'Person'
    if results.count < 1
      return nil
    else
      results.first
    end
  end

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

  def announce_sales(r, person)
    total_sales = person.sales_today
    r.Say 'Hello, ' + person.first_name + '.'
    r.Say 'You have ' + pluralize(person.sales_today.to_s, 'sale') + ' today.'
    for employee in person.employees.where(active: true) do
      next if employee.sales_today < 1
      r.Say employee.first_name + ' ' + employee.last_name + ' has ' +
                pluralize(employee.sales_today.to_s, 'sale') + ' today'
      total_sales += employee.sales_today
    end
    if person.employees.where(active: true).count > 0
      r.Say 'The total number of sales for you and your employees is ' +
                total_sales.to_s + '.'
    end
  end

  def no_records_found(r)
    r.Say 'Hello.'
    r.Say 'Unfortunately we could not locate your records based on the current phone number.'
    r.Say 'Please update your phone number by contacting the helpdesk at support dot RBD connect dot com.'
  end

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

