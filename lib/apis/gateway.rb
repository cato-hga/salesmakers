require 'twilio-ruby'
require 'open-uri'

class Gateway

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
    sender.log? 'send_sms',
                person,
                nil,
                nil,
                nil,
                text

    SMSMessage.create from_num: unformat_number(@from),
                      from_person_id: sender.id,
                      to_num: unformat_number(phone),
                      to_person_id: person.id,
                      message: text
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

  private

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
end

