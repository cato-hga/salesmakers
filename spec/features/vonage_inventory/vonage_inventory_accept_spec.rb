require 'rails_helper'

describe 'Inventory Accept page' do

  let(:person1) { create :person, position: position, display_name: 'person1' }
  let(:person2) { create :person, position: position, display_name: 'person2'}

  let!(:vonage_transfer1) {create :vonage_transfer, to_person: person1, from_person: person2, vonage_device: vonage_device1, rejected: false }
  let!(:vonage_transfer2) {create :vonage_transfer, to_person: person1, vonage_device: vonage_device2, accepted: true }
  let!(:vonage_transfer3) {create :vonage_transfer, to_person: person2, vonage_device: vonage_device3, rejected: true  }
  let!(:vonage_transfer4) {create :vonage_transfer, to_person: person1, vonage_device: vonage_device4, rejected: true  }
  let!(:vonage_transfer5) {create :vonage_transfer, to_person: person1, from_person: person2, vonage_device: vonage_device5, rejected: false  }

  let!(:vonage_device1) { create :vonage_device, person: person1, mac_id: '087240281acd'}
  let!(:vonage_device2) { create :vonage_device, person: person1, mac_id: '297369232acd'}
  let!(:vonage_device3) { create :vonage_device, person: person2, mac_id: '2737227397ac'}
  let!(:vonage_device4) { create :vonage_device, person: person1, mac_id: 'aabc12537527'}
  let!(:vonage_device5) { create :vonage_device, person: person1, mac_id: 'aacc12537522'}

  let(:vonage) { create :project, name: 'Vonage' }
  let(:area) { create :area, project: vonage }
  let(:location) { create :location, channel: walmart }
  let(:walmart) { create :channel, name: 'Walmart' }
  let!(:location_area) { create :location_area,
                                location: location,
                                area: person1_area.area }
  let!(:person1_area) { create :person_area, person: person1, area: area }

  let(:position) { create :position, permissions:[permission_accept, permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group'}
  let(:permission_accept) { Permission.new key: 'vonage_device_accept',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_group_sale) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'vonage_sale_create',
                                           permission_group: permission_group_sale,
                                           description: 'Test Description' }

  context 'for employee' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person1.email)
      visit accept_vonage_devices_path
    end

    it 'displays mac ids assigned to them, and not accepted/rejected already' do
      expect(page).to have_content vonage_device5.mac_id
      expect(page).to have_content vonage_device1.mac_id
    end

    it 'does not display macs not assigned to them, or are rejected/accepted already' do
      expect(page).not_to have_content vonage_device2.mac_id
      expect(page).not_to have_content vonage_device3.mac_id
      expect(page).not_to have_content vonage_device4.mac_id
    end

    it 'handles one transfer being accepted' do
      check "vonage_accept0"
      click_on "Complete"
      vonage_transfer1.reload
      vonage_transfer5.reload
      expect(vonage_transfer1.accepted).to eq(true)
      expect(vonage_transfer5.accepted).to eq(false)
    end

    it 'handles one transfer being rejected' do
      check "vonage_reject0"
      click_on 'Complete'
      vonage_transfer1.reload
      vonage_transfer5.reload
      vonage_device1.reload
      expect(vonage_transfer1.rejected).to eq(true)
      expect(vonage_transfer1.rejection_time).not_to be_nil
      expect(vonage_transfer5.rejected).to eq(false)
      expect(vonage_device1.person).to eq(person2)
    end

    it 'handles all transfers being accepted' do
      check "vonage_accept0"
      check "vonage_accept1"
      click_on "Complete"
      vonage_transfer1.reload
      vonage_transfer5.reload
      expect(vonage_transfer1.accepted).to eq(true)
      expect(vonage_transfer5.accepted).to eq(true)
    end

    it 'handles all transfers being rejected' do
      check "vonage_reject0"
      check "vonage_reject1"
      click_on "Complete"
      vonage_transfer1.reload
      vonage_transfer5.reload
      vonage_device1.reload
      vonage_device5.reload
      expect(vonage_transfer1.rejected).to eq(true)
      expect(vonage_transfer5.rejected).to eq(true)
      expect(vonage_device1.person).to eq(person2)
      expect(vonage_device5.person).to eq(person2)
      expect(vonage_transfer1.rejection_time).not_to be_nil
      expect(vonage_transfer5.rejection_time).not_to be_nil
    end

    it 'redirects to root_path and displays success message' do
      check "vonage_reject0"
      click_on "Complete"
      expect(current_path).to eq(new_vonage_sale_path)
      expect(page).to have_content('You have successfully Accepted/Rejected the device(s) that were issued to you. Please check your email for further details.')
    end

    it 'renders accept and displays failure message' do
      click_on "Complete"
      expect(current_path).to eq(accept_vonage_devices_path)
      expect(page).to have_content('You must accept/reject a device.')
    end
  end
end