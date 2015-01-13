require 'apis/gateway'

class TwilioController < ApplicationController
  include Webhookable

  before_action :set_gateway
  after_action :set_header
  skip_before_action :verify_authenticity_token
  skip_before_action CASClient::Frameworks::Rails::Filter

  def incoming_voice
    from = incoming_voice_params[:From]
    response = @gateway.handle_call from
    render_twiml response
  end

  def incoming_sms
    from = incoming_sms_params[:From]
    to = incoming_sms_params[:To]
    message = incoming_sms_params[:Body]
    sid = incoming_sms_params[:MessageSid]
    @gateway.handle_sms from, to, message, sid
    render nothing: true
  end

  private

  def set_gateway
    @gateway = Gateway.new
  end

  def incoming_voice_params
    params.permit :From
  end

  def incoming_sms_params
    params.permit :From, :To, :Body, :MessageSid
  end
end