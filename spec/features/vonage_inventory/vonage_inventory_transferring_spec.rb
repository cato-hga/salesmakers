require 'rails_helper'

describe 'Inventory Transferring page' do
  let(:person1) { create :person, position: position, display_name: 'person1' }
  let(:person2) { create :person, position: position, display_name: 'person2' }
  let(:manager) { create :person, position: position, display_name: 'manager' }

  let!(:person1_pa) { create :person_area, person: person1, area: area1 }
  let!(:person2_pa) { create :person_area, person: person2, area: area2 }
  let!(:manager_pa) { create :person_area, person: manager, area: area1, manages: true }

  let(:area1) { create :area, name: 'area1' }
  let(:area2) { create :area, name: 'area2' }

  let!(:vonage_device1) { create :vonage_device, person: manager, mac_id: '723556789abc' }
  let!(:vonage_device2) { create :vonage_device, person: person2, mac_id: '223456789abc' }
  let!(:vonage_device3) { create :vonage_device, person: manager, mac_id: '323456789abc' }
  let!(:vonage_device4) { create :vonage_device, person: person1, mac_id: '864456789abc' }
  let!(:vonage_device5) { create :vonage_device, person: person1, mac_id: '238456789abc' }

  let(:position) { create :position, permissions: [permission_transfer] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_transfer) { Permission.new key: 'vonage_device_transfer',
                                             permission_group: permission_group,
                                             description: 'Test Description' }
  context 'for unauthorized users' do
    let(:unauth_person) { create :person }

    it 'shows the you are not authorized page' do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit transfer_vonage_devices_path
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  context 'for an authorized employee' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person1.email)
      visit transfer_vonage_devices_path
    end

    it 'shows the Vonage Inventory Transferring page' do
      expect(page).to have_content('Vonage Inventory Transfer')
    end

    it 'can select their supervisor/manager' do
      expect(page).to have_select 'to_person', text: manager.display_name
    end
  end

  context 'for an authorized manager' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(manager.email)
      visit transfer_vonage_devices_path
    end

    it 'can select from a list of employees' do
      expect(page).to have_select 'to_person', text: person1.display_name
    end

    it 'a manager will not see their name in the To person dropdown' do
      expect(page).not_to have_select 'to_person', text: manager.display_name
    end

    it 'displays a list of correct mac ids' do
      expect(page).to have_content vonage_device1.mac_id
    end

    it 'does not display mac ids that are not available' do
      expect(page).not_to have_content vonage_device2.mac_id
    end

    context 'for form submission' do
      subject {
        select person1.display_name, from: 'Select Person'
        page.check 'vonage_devices0'
        page.check 'vonage_devices1'
        click_on 'Transfer'
      }

      it 'creates a vonage transfer record' do
        expect { subject }.to change(VonageTransfer, :count).by(2)
      end

      it 'adds all the correct attributes to a vonage device' do
        subject
        vonage_device1.reload
        expect(vonage_device1.person_id).to eq(person1.id)
      end

      it 'assigns the correct attributes to the vonage transfer record' do
        subject
        vonage_transfer = VonageTransfer.first
        expect(vonage_transfer.to_person).to eq(person1)
        expect(vonage_transfer.from_person).to eq(manager)
      end
    end
  end
end
