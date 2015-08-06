require 'rails_helper'


describe 'Inventory receiving page' do

  let(:person) { create :person, position: position }
  let(:position) {create :position, permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group'}
  let(:permission_create) { Permission.new key: 'vonage_inventory_receive_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  context 'for unauthorized users' do

    let(:unauth_person) { create :person }


    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
       visit vonage_inventory_receivings_path
    end

    it 'shows the You are not authorized page' do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end


  context 'for authorized users' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
       visit vonage_inventory_receivings_path
    end

    it 'shows the Home page' do
      expect(page).to have_content('')
    end
  end
end