require 'rails_helper'

describe VonageInventoryMailer do

  describe 'vonage_inventory_email' do
    let(:device) { create :vonage_device }
    let(:device_2) { create :vonage_device }
    let(:person) { create :person }
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
      source = mail.body.parts.find { |p| p.content_type.match /html/ }.body.raw_source
      expect(source).to include(device.mac_id)
      expect(source).to include(device_2.mac_id)
    end
  end

  describe 'vonage_inventory_accept_email' do

    let(:person) { create :person }
    let!(:transfer1) { create :vonage_transfer, accepted: true }
    let!(:transfer2) { create :vonage_transfer, rejected: true }

    let(:mail) { VonageInventoryMailer.inventory_accept_mailer(person, [transfer1], [transfer2]) }

    it 'sends an email with correct subject' do

      expect(mail.subject).to include('Vonage Inventory Accept')
    end

    it 'sends an email to the persons email' do

      expect(mail.to).to include(person.email)
    end
    it 'sends an email with the correct "from" email' do
      expect(mail.from).to include('development@retaildoneright.com')
    end

    it 'sends an email with the correct device info' do
      source = mail.body.parts.find { |p| p.content_type.match /html/ }.body.raw_source
      expect(source).to include(transfer1.vonage_device.mac_id)
      expect(source).to include(transfer2.vonage_device.mac_id)
    end
  end

  describe 'vonage_inventory_reclaim_email' do
    let!(:person1) { create :person, display_name: 'User1' }
    let!(:person2) { create :person, display_name: 'User2' }
    let!(:person) { create :person }

    let(:device1) { create :vonage_device }
    let(:device2) { create :vonage_device }
    let(:vonage_device_ids) { [[person1.id,device1.id], [person2.id,device2.id]] }

    let(:mail) { VonageInventoryMailer.inventory_reclaim_mailer(person, vonage_device_ids) }

    it 'sends an email with correct subject' do
      expect(mail.subject).to include('Vonage Device(s) Reclaimed')
    end

    it 'sends an email to the persons email' do
      expect(mail.to).to include(person.email)
    end
    it 'sends an email with the correct "from" email' do
      expect(mail.from).to include('development@retaildoneright.com')
    end

    it 'sends an email with the correct mailer info' do
      source = mail.body.parts.find { |p| p.content_type.match /html/ }.body.raw_source
      expect(source).to include(device1.mac_id)
      expect(source).to include(device2.mac_id)
      expect(source).to include(person1.display_name)
      expect(source).to include(person2.display_name)
      expect(source).to include('2 Reclaimed Devices')
    end
  end
end