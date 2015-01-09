class TwilioController < ApplicationController
  include Webhookable

  after_action :set_header
  skip_before_action :verify_authenticity_token

  def incoming
    calling_number = params['From']
    calling_number = calling_number.sub! '+1', ''
    response = Twilio::TwiML::Response.new do |r|

    end

    render_twiml response
  end

  private

  def incoming_params
    params.permit 'From'
  end

end