require 'rails_helper'

describe TwilioController do
  let(:from) { '+18635214572' }

  describe 'POST incoming_voice' do
    before { post :incoming_voice, From: from }

    it 'returns a success status' do
      expect(response).to be_success
    end
  end

  describe 'POST incoming_sms' do
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

    it 'does not create a LogEntry if there is no matching Person' do
      expect {
        post :incoming_sms,
             From: '+18774456611',
             To: '+17272286225',
             Body: 'This is a sample incoming message.',
             MessageSid: 'SM12345678901234567890'
      }.not_to change(LogEntry, :count)
    end
  end

end