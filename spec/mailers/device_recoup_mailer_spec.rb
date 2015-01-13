require 'rails_helper'

describe DeviceRecoupMailer do

  describe 'recoup_emailer' do
    let(:device) { create :device }
    let(:person) { create :person }
    let(:mail) { DeviceRecoupMailer.recoup_mailer(device, person) }

    it 'sends an email with correct subject' do
      expect(mail.subject).to include('Asset Returned')
    end
    it 'sends an email with the correct "to" emails' do
      expect(mail.to).to eq(person.personal_email)
      expect(mail.to).to eq('assets@retaildoneright.com')
    end
    it 'sends an email with the correct "from" email' do
      expect(mail.from).to eq('development@retaildoneright.com')
    end
    it 'sends an email with the correct device info' do
      expect(mail.body.encoded).to match(device.serial)
    end
    it 'sends an email with the correct person info' do
      expect(mail.body.encoded).to match(person.name)
    end
  end
end