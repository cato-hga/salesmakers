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

  describe '#email_bounceback' do
    let(:bounce) {
      {
          :id => 816949422,
          :type => "HardBounce",
          :type_code => 1,
          :name => "Hard bounce",
          :message_id => "12345678-1234-1234-1234-123456789012",
          :description => "The server was unable to deliver your message (ex: unknown user, mailbox not found).",
          :details => "smtp;554 delivery error: dd This user doesn't have a yahoo.com account (foo@bar.com) [0] - mta.bar.com",
          :email => "foo@bar.com",
          :bounced_at => "2015-03-31T11:02:45.3592038-04:00",
          :dump_available => true,
          :inactive => true,
          :can_activate => true,
          :subject => "Your Email Subject Here"
      }
    }
    let(:candidate) { create :candidate, email: 'foo@bar.com', person: recruiter }
    let(:recruiter) { create :person }
    let(:mail) { NotificationMailer.email_bounceback(bounce) }

    it 'sends from notifications@salesmakersinc.com' do
      expect(mail.from).to include('notifications@salesmakersinc.com')
    end
    it 'mails the to_persons email address' do
      candidate
      expect(mail.to).to include(recruiter.email)
    end
    it 'contains "Email Bounceback" in the subject' do
      expect(mail.subject).to include('Email Bounceback')
    end
    it 'contains the candidate name in the body if there is a candidate' do
      candidate
      expect(mail.body).to include(candidate.name)
    end
    it 'works without a candidate attached' do
      expect(mail.body).to include("foo@bar.com")
    end
  end
end