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
    it 'sends an email with the correct "to" emails' do
      expect(mail.to).to include(person.personal_email)
      expect(mail.to).to include('assets@retaildoneright.com')
    end
    it 'sends an email with the correct "from" email' do
      expect(mail.from).to include('development@retaildoneright.com')
    end
    it 'sends an email with the correct device info' do
      expect(mail.body.encoded).to include(device.serial)
      expect(mail.body.encoded).to include(line.identifier)
    end
    it 'sends an email with the correct person info' do
      expect(mail.body.encoded).to include(person.name)
    end

    it 'sends an email with the correct note' do
      expect(mail.body.encoded).to include(note)
    end
  end
end