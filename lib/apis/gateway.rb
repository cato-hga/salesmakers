require 'twilio-ruby'

class Gateway
  def initialize
    @from = '+17272286225'
    @client = Twilio::REST::Client.new 'AC96a051482517673481ee177d64d52bcf',
                                       '806dd03205d48972b9837da98ccf0348'
  end

  def send_text(number, text)
    formatted_number = number.strip.gsub /[^0-9]/, ''
    if formatted_number.length == 10
      formatted_number = '+1' + formatted_number
    elsif formatted_number.length == 11 and
        formatted_number[0] == '1'
      formatted_number = '+' + formatted_number
    end
    @client.account.messages.create to: formatted_number,
                                    from: @from,
                                    body: text
  end
end

