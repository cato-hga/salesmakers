require 'rails_helper'

describe 'Inventory Transferring page' do

  let(:person) { create :person, position: position }
  let(:position) { create :position, permissions:[permission_transfer] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group'}
  let(:permission_transfer) { Permission.new key: 'vonage_device_transfer',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  context 'for unauthorized users' do

    let(:unauth_person) { create :person }

    it 'shows the you are not authorized page' do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_vonage_transfer_path
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end
    context 'for authorized users' do

      it 'shows the Vonage Inventory Transferring page' do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit new_vonage_transfer_path
        expect(page).to have_content('Vonage Inventory Transferring')

      end
    end
  end