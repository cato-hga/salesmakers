require 'rails_helper'

describe 'Inventory Accept page' do

  let(:person1) { create :person, position: position, display_name: 'person1' }
  let(:person2) { create :person, position: position, display_name: 'person2'}
  # let(:person3) { create :person, position: position, display_name: 'person3'}


  # let(:vonage_transfer1) {create :vonage_transfer, to_person: person1, vonage_device: vonage_device2, accepted: true}
  let!(:vonage_transfer1) {create :vonage_transfer, to_person: person1, vonage_device: vonage_device1, rejected: false }
  let!(:vonage_transfer2) {create :vonage_transfer, to_person: person1, vonage_device: vonage_device2, accepted: true }
  let!(:vonage_transfer3) {create :vonage_transfer, to_person: person2, vonage_device: vonage_device3, rejected: true  }

  let!(:vonage_device1) { create :vonage_device, person: person1, mac_id: '087240281acd'}
  let!(:vonage_device2) { create :vonage_device, person: person1, mac_id: '297369232acd'}
  let!(:vonage_device3) { create :vonage_device, person: person2, mac_id: '2737227397ac'}


  let(:position) { create :position, permissions:[permission_accept] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group'}
  let(:permission_accept) { Permission.new key: 'vonage_device_accept',
                                           permission_group: permission_group,
                                           description: 'Test Description' }

  context 'for employee' do
    subject {
      page.check 'accepted'
      click_on 'Accept'
    }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person1.email)
      visit accept_vonage_devices_path
    end
    it 'displays mac ids assigned to them' do
      expect(page).to have_content vonage_device1.mac_id
      expect(page).not_to have_content vonage_device2.mac_id
    end

    it 'updates vonage transfer record when accepted' do

      subject
      expect(vonage_transfer2.accepted).to eq(true)
    end

    it 'will not displays mac ids that are already accepted'
  end
end