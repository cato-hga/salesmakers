require 'rails_helper'

describe DeviceRecoupMailer do

  describe 'recoup_emailer' do
    let(:device) { create :device, line: line }
    let(:line) { create :line }
    let(:person) { create :person, personal_email: 'test@test.com' }
    let(:note) { 'Test' }
    let(:mail) { DeviceRecoupMailer.recoup_mailer(device, person, note) }

    it 'sends an email with correct subject' do
      expect(mail.subject).to include('Asset Returned')
    end
    it 'sends an email with the persons personal email (if they have one)' do
      expect(mail.to).to include(person.personal_email)
      expect(mail.to).to include('assets@retaildoneright.com')
      expect(mail.to.count).to eq(2)
    end

    it 'sends an email to just assets if there is no personal email on file' do
      person.personal_email = nil
      expect(mail.to).to include('assets@retaildoneright.com')
      expect(mail.to.count).to eq(1)
    end

    it 'sends an email with the correct "from" email' do
      expect(mail.from).to include('development@retaildoneright.com')
    end

    it 'sends an email with the correct device info' do
      expect(mail.body.encoded).to include(device.serial)
      expect(mail.body.encoded).to include(line.identifier)
    end

    it 'handles no line being attached to a device' do
      device.line = nil
      expect(mail.body.encoded).to include('N/A')
    end
    it 'sends an email with the correct person info' do
      expect(mail.body.encoded).to include(person.name)
      expect(mail.body.encoded).to include(person.mobile_phone)
    end

    it 'handles not having a phone number for a person' do
      person.mobile_phone = nil
      expect(mail.body.encoded).to include('N/A')
    end

    it 'sends an email with the correct note' do
      expect(mail.body.encoded).to include(note)
    end
  end
end