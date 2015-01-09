require 'rails_helper'
require 'apis/gateway'

describe 'SMS Gateway API', vcr: true do
  let(:gateway) { Gateway.new }
  let(:number) { '8635214572' }
  let(:message) { 'This is a test message' }

  it 'should send a text message' do
    response = gateway.send_text('8635214572', message)
    expect(response).to be_a(Twilio::REST::Message)
  end

  it 'should call a phone number with a phone call' do
    response = gateway.call_with_message('8635214572', message)
    expect(response).to be_a(Twilio::REST::Call)
  end

end