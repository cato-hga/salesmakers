require 'twilio-ruby'
require 'open-uri'
require 'apis/twilio/calls'
require 'apis/twilio/incoming_sms'
require 'apis/twilio/outgoing_sms'

class Gateway
  include ActionView::Helpers::TextHelper
  include Twilio::Calls
  include Twilio::IncomingSMS
  include Twilio::OutgoingSMS

  def initialize(from = '+17272286225')
    @from = from
    @message_twimlet_base = 'http://twimlets.com/message?'
    @sid = 'AC96a051482517673481ee177d64d52bcf'
    @auth_token = '806dd03205d48972b9837da98ccf0348'
    @client = Twilio::REST::Client.new @sid,
                                       @auth_token
  end

  def number_validation number
    lookup_client = Twilio::REST::LookupsClient.new @sid, @auth_token
    response = lookup_client.phone_numbers.get number, type: 'carrier'
    validation = OpenStruct.new
    validation.valid = valid? response
    if validation.valid
      type = response.andand.carrier.andand['type']
      validation.mobile = (type == 'mobile' || type == 'voip') ? true : false
    else
      validation.mobile = false
    end
    validation
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

  def valid? response
    begin
      response.phone_number
      return true
    rescue
      return false
    end
  end
end

