require 'rails_helper'

describe TwilioController do
  let(:from) { '+17274872633' }

  describe 'POST incoming_voice' do
    before { post :incoming_voice, From: from }

    it 'returns a success status' do
      expect(response).to be_success
    end
  end

  describe 'POST incoming_sms' do
    let(:to_person) { create :person }
    let(:from_person) { Person.first }
    let!(:outgoing_message) {
      create :sms_message,
             to_num: to_person.mobile_phone,
             to_person_id: to_person.id,
             from_person_id: from_person.id
    }

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
      subject
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      email = ActionMailer::Base.deliveries.first
      expect(email.subject).to eq('SMS Reply from ' + to_person.display_name)
      expect(email.to).to eq([from_person.email])
      expect(email.body.to_s).to match(/This is a sample incoming message/)
    end

    it 'sends an email to everyone applicable when not a reply' do
      post :incoming_sms,
           From: '+18635214572',
           To: '+12345678901',
           Body: 'This is a message that starts a new thread.',
           MessageSid: 'SM09876543210987654321'
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      email = ActionMailer::Base.deliveries.first
      expect(email.subject).to eq('New SMS Thread Started by ' + from_person.display_name)
      expect(email.to).to eq([from_person.email])
      expect(email.body.to_s).to match(/This is a message that starts a new thread/)
    end
  end

end