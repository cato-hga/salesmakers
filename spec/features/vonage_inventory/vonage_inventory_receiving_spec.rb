require 'rails_helper'


describe 'Inventory receiving page' do

  let(:person) { create :person, position: position }
  let(:position) {create :position, permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group'}
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
      # before(:each) do
      #   CASClient::Frameworks::Rails::Filter.fake(person.email)
      #    visit new_vonage_device_path
      # end

      it 'shows the Vonage Inventory Receiving page' do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit new_vonage_device_path
        expect(page).to have_content('Vonage Inventory Receiving')
      end
    end

    describe 'form submission' do

      context 'with all blank data' do
        it 'renders :new and shows all relevant error messages' do
          CASClient::Frameworks::Rails::Filter.fake(person.email)
          visit new_vonage_device_path
          click_on 'Receive'
          expect(page).to have_content "Po number is invalid"
          expect(page).to have_content "Mac is invalid"
          expect(page).to have_content "Receive date can't be blank"
        end
      end
    end
  end
