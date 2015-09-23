require 'rails_helper'

describe 'Inventory Receiving page' do

  let(:vonage_manager) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'vonage_device_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  context 'for unauthorized users' do
    let(:unauth_person) { create :person }

    it 'shows the You are not authorized page' do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_vonage_device_path
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  context 'for authorized users' do
    subject {
      fill_in 'po_number', with: '123456789012'
      fill_in 'receive_date', with: Date.today.strftime('%m/%d/%Y')
      fill_in 'mac_id[]', with: 'ab1234567890'
      click_on 'Receive Devices'
    }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(vonage_manager.email)
      visit new_vonage_device_path
    end

    it 'shows the Vonage Inventory Receiving page' do
      expect(page).to have_content('Vonage Inventory Receiving')
    end

    it 'assigns the correct person to the device' do
      subject
      expect(VonageDevice.first.person_id).to eq(vonage_manager.id)
    end

    it 'raises the VonageDevice count by 1' do
      expect { subject }.to change(VonageDevice, :count).by(1)
    end

    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end
  end
end