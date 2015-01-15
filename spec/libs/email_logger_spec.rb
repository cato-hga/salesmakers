require 'rails_helper'

describe 'Email logging' do
  let!(:person) { create :person }
  let(:subject) { 'This is a subject' }
  let(:content) { 'This is some content' }
  let!(:email_message) {
    NotificationMailer.simple_mail(person.email, subject, content).deliver
    EmailMessage.first
  }

  it 'sends the email' do
    expect(ActionMailer::Base.deliveries.size).not_to eq(0)
  end

  it 'saves the from_email of a sent message' do
    expect(email_message.from_email).to include('development@retaildoneright.com')
  end

  it 'saves the to_email of a sent message' do
    expect(email_message.to_email).to include(person.email)
  end

  it 'saves the subject of a sent message' do
    expect(email_message.subject).to include(subject)
  end

  it 'saves the content of a sent message' do
    expect(email_message.content).to include(content)
  end

  describe 'communication log entries' do
    it 'creates a CommunicationLogEntry' do
      expect(CommunicationLogEntry.count).to eq(1)
    end

    it 'attaches the CommunicationLogEntry to the person' do
      entry = CommunicationLogEntry.first
      expect(entry.person).to eq(person)
    end
  end

end