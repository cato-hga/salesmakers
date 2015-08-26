require 'rails_helper'

describe VonageInventoryMailer do

  describe 'vonage_inventory_email' do
    let(:device) { create :vonage_device }
    let(:device_2) { create :vonage_device }
    let(:person) { create :person, email: 'test@test.com' }
    let(:vonage_device_ids) { [device.id, device_2.id] }

    let(:mail) { VonageInventoryMailer.inventory_receiving_mailer(person, vonage_device_ids) }

    it 'sends an email with correct subject' do
      expect(mail.subject).to include('Vonage Inventory Received')

    end
    it 'sends an email to the persons email ' do
      expect(mail.to).to include(person.email)
    end

    it 'sends an email with the correct "from" email' do
      expect(mail.from).to include('development@retaildoneright.com')
    end

    it 'sends an email with the correct device info' do
      source = mail.body.parts.find {|p| p.content_type.match /html/}.body.raw_source
      expect(source).to include(device.mac_id)
      expect(source).to include(device_2.mac_id)
    end
  end
end