require 'rails_helper'

describe NotificationMailer do

  let(:person) { create :person }
  let(:candidate) { create :candidate }
  let(:recruiter) { create :person, position: position }
  let(:position) {
    create :position,
           name: 'Advocate',
           hq: true,
           twilio_number: "+18635214572"
  }

  let(:person_message) { create :sms_message, from_person: person, to_person: recruiter, inbound: true }
  let(:candidate_message) { create :sms_message, from_candidate: candidate, to_person: recruiter, inbound: true }

  describe '#sms_reply' do
    context 'shared context' do
      let(:mail) { NotificationMailer.sms_reply(person_message) }
      it 'sends from development@retaildoneright.com' do
        expect(mail.from).to include('development@retaildoneright.com')
      end
      it 'mails the to_persons email address' do
        expect(mail.to).to include(recruiter.email)
      end
      it 'does not include a CC to CandidateSMS if it is not from a candidate' do
        expect(mail.cc).to be_blank
        #This needs to be changed to ".not_to include 'candidatesms@salesmakersinc.com' if we ever add a CC again"
      end
      it 'contains SMS Reply from in the subject' do
        expect(mail.subject).to include('SMS Reply from')
      end
    end

    context 'if from a candidate' do
      let(:mail) { NotificationMailer.sms_reply(candidate_message) }
      it "CC's a generic inbox if the text reply is from a candidate" do
        expect(mail.from).to include('development@retaildoneright.com')
        expect(mail.to).to include(recruiter.email)
        expect(mail.cc).to include('candidatesms@salesmakersinc.com')
      end

    end
  end

  describe '#new_sms_thread' do
    context 'shared context' do
      let(:mail) { NotificationMailer.new_sms_thread(person_message) }
      it 'sends from development@retaildoneright.com' do
        expect(mail.from).to include('development@retaildoneright.com')
      end
      it 'mails the to_persons email address' do
        expect(mail.to).to include(recruiter.email)
      end
      it 'does not include a CC to CandidateSMS if it is not from a candidate' do
        expect(mail.cc).to be_blank
        #This needs to be changed to ".not_to include 'candidatesms@salesmakersinc.com' if we ever add a CC again"
      end
      it 'contains SMS Reply from in the subject' do
        expect(mail.subject).to include('New SMS Thread Started by')
      end
    end

    context 'if from a candidate' do
      let(:mail) { NotificationMailer.new_sms_thread(candidate_message) }
      it "CC's a generic inbox if the text reply is from a candidate" do
        expect(mail.from).to include('development@retaildoneright.com')
        expect(mail.to).to include(recruiter.email)
        expect(mail.cc).to include('candidatesms@salesmakersinc.com')
      end
    end
  end
end