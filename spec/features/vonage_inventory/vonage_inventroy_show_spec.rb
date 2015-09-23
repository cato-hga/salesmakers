require 'rails_helper'

describe 'Inventory Show page' do
  include ActionView::Helpers
  include ApplicationHelper

  let(:vonage_employee) { create :person, position: position }
  let(:vonage_manager) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'vonage_device_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }

  let!(:receive_log_entry) { create :log_entry, person: vonage_manager, trackable: received_device }
  let!(:transfer_log_entry) { create :log_entry, person: vonage_manager, action: 'transfer', trackable: transferred_device, referenceable: vonage_accepted_transfer }
  let!(:accepted_log_entry) { create :log_entry, person: vonage_employee, action: 'accept', trackable: accepted_device, referenceable: vonage_accepted_transfer }
  let!(:rejected_log_entry) { create :log_entry, person: vonage_employee, action: 'reject', trackable: rejected_device, referenceable: vonage_rejected_transfer }
  let!(:reclaimed_log_entry) { create :log_entry, person: vonage_manager, trackable: reclaimed_device, action: 'reclaim', referenceable: reclaimed_device.person }

  let(:received_device) { create :vonage_device, person: vonage_manager, mac_id: '723556789aaa' }
  let(:transferred_device) { create :vonage_device, person: vonage_employee, mac_id: '723556789bbb' }
  let(:accepted_device) { create :vonage_device, person: vonage_employee, mac_id: '723556789ccc' }
  let(:rejected_device) { create :vonage_device, person: vonage_employee, mac_id: '723556789ddd' }
  let(:reclaimed_device) { create :vonage_device, person: vonage_manager, mac_id: '723556789dda' }

  let!(:vonage_accepted_transfer) { create :vonage_transfer, to_person: vonage_employee,
                                           from_person: vonage_manager, vonage_device: accepted_device, accepted: true }
  let!(:vonage_rejected_transfer) { create :vonage_transfer, to_person: vonage_employee,
                                           from_person: vonage_manager, vonage_device: rejected_device, rejected: true }


  context 'for unauthorized users' do
    let(:unauth_person) { create :person }

    it 'shows the You are not authorized page' do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit vonage_device_path(transferred_device.id)
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  context 'for authorized users' do
    it 'shows the Vonage Show page' do
      CASClient::Frameworks::Rails::Filter.fake(vonage_manager.email)
      visit vonage_device_path(received_device)
      expect(page).to have_content(received_device.mac_id)
    end

    it 'creates a log entry when a device is received' do
      CASClient::Frameworks::Rails::Filter.fake(vonage_manager.email)
      visit vonage_device_path(received_device)
      expect(page).to have_content("Received #{received_device.mac_id} on #{short_date(received_device.created_at)} as part of PO #{received_device.po_number}")
    end

    it 'Creates a log entry when a device has been transferred' do
      CASClient::Frameworks::Rails::Filter.fake(vonage_manager.email)
      visit vonage_device_path(transferred_device)
      expect(page).to have_content("#{transferred_device.mac_id} was transferred to #{vonage_accepted_transfer.to_person.display_name} by #{vonage_accepted_transfer.from_person.display_name} on #{friendly_datetime(vonage_accepted_transfer.created_at)}")
    end

    it 'Creates a log entry when a device has been accepted by an employee' do
      CASClient::Frameworks::Rails::Filter.fake(vonage_manager.email)
      visit vonage_device_path(accepted_device)
      expect(page).to have_content("#{accepted_device.mac_id} has been accepted by #{vonage_accepted_transfer.to_person.display_name} on #{friendly_datetime(vonage_accepted_transfer.created_at)}")
    end

    it 'Creates a log entry when a device has been rejected by an employee' do
      CASClient::Frameworks::Rails::Filter.fake(vonage_manager.email)
      visit vonage_device_path(rejected_device)
      expect(page).to have_content("#{rejected_device.mac_id} has been rejected by #{vonage_rejected_transfer.to_person.display_name} on #{friendly_datetime(vonage_rejected_transfer.created_at)}")
    end

    it 'Creates a log entry when a device has been reclaimed by a manager' do
      CASClient::Frameworks::Rails::Filter.fake(vonage_manager.email)
      visit vonage_device_path(reclaimed_device)
      expect(page).to have_content("#{reclaimed_device.mac_id} has been reclaimed from #{vonage_manager.display_name}")
    end
  end
end

