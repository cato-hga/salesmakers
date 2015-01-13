require 'twilio-ruby'
require 'open-uri'

class Gateway
  include ActionView::Helpers::TextHelper

  def initialize
    @from = '+17272286225'
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

    message = SMSMessage.new from_num: unformat_number(@from),
                      from_person_id: sender.id,
                      to_num: unformat_number(phone),
                      to_person_id: person.id,
                      message: text,
                      sid: response.sid

    if message.save
      sender.log? 'send_sms',
                  person,
                  message,
                  nil,
                  nil,
                  text
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
    from_number = unformat_number from
    from_person = lookup_person from_number
    reply_to_message = lookup_reply_to from_person
    from_person_id = from_person ? from_person.id : nil
    to_person = reply_to_message ? reply_to_message.from_person : nil
    to_person_id = to_person ? to_person.id : nil
    reply_to_sms_message_id = reply_to_message ? reply_to_message.id : nil
    incoming_message = SMSMessage.new from_num: from_number,
                                      to_num: unformat_number(to),
                                      from_person_id: from_person_id,
                                      to_person_id: to_person_id,
                                      inbound: true,
                                      reply_to_sms_message_id: reply_to_sms_message_id,
                                      message: message,
                                      sid: sid
    if incoming_message.save
      if from_person
        from_person.log? 'receive_sms',
                         incoming_message,
                         to_person,
                         nil,
                         nil,
                         message
      end
      if reply_to_message
        reply_to_message.update replied_to: true
        NotificationMailer.sms_reply(incoming_message).deliver
      end
    end
  end

  def handle_call(calling_number)
    calling_number = unformat_number calling_number
    person = lookup_person calling_number
    Twilio::TwiML::Response.new do |r|
      if person
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
      else
        r.Say 'Hello.'
        r.Say 'Unfortunately we could not locate your records based on the current phone number.'
        r.Say 'Please update your phone number by contacting the helpdesk at support dot RBD connect dot com.'
      end
      r.Say 'Thank You. Goodbye.'
    end
  end

  private

  def lookup_reply_to(person)
    return nil unless person
    messages = SMSMessage.where(
        'created_at > ? AND to_person_id = ?',
        Time.now - 1.day,
        person.id
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

  def lookup_person(number)
    people = Person.where mobile_phone: number
    people = Person.where office_phone: number unless people.count > 0
    people = Person.where home_phone: number unless people.count > 0
    if people.count < 1
      return nil
    else
      people.first
    end
  end
end

