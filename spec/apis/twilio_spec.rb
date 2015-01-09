require 'rails_helper'
require 'apis/gateway'

describe 'SMS Gateway API', vcr: true do
  let(:gateway) { Gateway.new }
  let(:message) { 'This is a test message' }

  describe 'to a phone number' do
    let(:number) { '8635214572' }

    it 'sends a text message' do
      response = gateway.send_text('8635214572', message)
      expect(response).to be_a(Twilio::REST::Message)
    end

    it 'does not create a log entry upon texting' do
      expect {
        gateway.send_text('8635214572', message)
      }.not_to change(LogEntry, :count)
    end
  end

  describe 'to a person' do
    let(:person) { create :person }
    let(:sender) { Person.first }

    it 'sends a text message to a person' do
      response = gateway.send_text_to_person(person, message, sender)
      expect(response).to be_a(Twilio::REST::Message)
    end

    it 'creates a log entry upon texting' do
      expect {
        gateway.send_text_to_person(person, message, sender)
      }.to change(LogEntry, :count).by(1)
    end
  end

  it 'calls a phone number with a phone call' do
    response = gateway.call_with_message('8635214572', message)
    expect(response).to be_a(Twilio::REST::Call)
  end

end