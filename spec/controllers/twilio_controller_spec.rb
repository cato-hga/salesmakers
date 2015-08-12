require 'rails_helper'

describe TwilioController do
  include ActiveJob::TestHelper

  let(:from) { '+17274985180' }

  describe 'POST incoming_voice' do
    before { post :incoming_voice, From: from }

    it 'returns a success status' do
      expect(response).to be_success
    end
  end

  describe 'POST incoming_sms' do
    let(:to_person) { create :person, mobile_phone: '7274985180' }
    let(:from_person) { create :person, mobile_phone: '8137164150', position: from_person_position }
    let(:from_person_position) { create :it_tech_position, :twilio }
    #let(:from_person) { create :administrator_person }
    let!(:outgoing_message) {
      create :sms_message,
             to_num: to_person.mobile_phone,
             to_person_id: to_person.id,
             from_person_id: from_person.id,
             from_num: from_person.mobile_phone
    }

    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }

    before(:example) do
      ActionMailer::Base.deliveries.clear
    end

    subject {
      post :incoming_sms,
           From: from,
           To: '+17272286225',
           Body: 'This is a sample incoming message.',
           MessageSid: 'SM12345678901234567890'
    }

    it 'creates a SMSMessage' do
      expect { subject }.to change(SMSMessage, :count).by(1)
    end

    it 'creates a LogEntry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end

    it 'creates CommunicationLogEntries' do
      expect(CommunicationLogEntry.count).to eq(2)
    end

    it 'does not create a LogEntry if there is no matching Person' do
      expect {
        post :incoming_sms,
             From: '+18774456611',
             To: '+17272286225',
             Body: 'This is a sample incoming message.',
             MessageSid: 'SM12345678901234567890'
      }.not_to change(LogEntry, :count)
    end

    it 'sends an email to a person being replied to' do
      expect(NotificationMailer).to receive(:sms_reply).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_later)
      subject
    end

    it 'sends an email to everyone applicable when not a reply' do
      expect(NotificationMailer).to receive(:new_sms_thread).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_later)
      post :incoming_sms,
           From: '+1' + from_person.mobile_phone,
           To: '+12345678901',
           Body: 'This is a message that starts a new thread.',
           MessageSid: 'SM09876543210987654321'
    end

    it 'sends an email when the phone number is not recognized' do
      expect(NotificationMailer).to receive(:new_sms_thread).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_later)
      post :incoming_sms,
           From: '+19914488899',
           To: '+12345678901',
           Body: 'This is a message from an unrecognized number.',
           MessageSid: 'SM09876543210987654321'
    end
  end
end
