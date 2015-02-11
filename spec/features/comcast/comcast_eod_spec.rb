require 'rails_helper'

describe 'Comcast End of Day' do
  let(:person) { create :comcast_employee, position: position }
  let(:position) { create :comcast_sales_position } #, permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'comcast_customer_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'comcast_customer_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let!(:comcast_customer) { create :comcast_customer, person: person }
  describe 'eod page' do
    context 'for authorized users' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit new_comcast_eod_path
      end

      it 'shows the New Lead page' do
        expect(page).to have_content('New Lead')
      end

      it 'has locations' do
        expect(page).to have_content(comcast_customer.name)
      end
    end

    context 'for unauthorized users' do
      let(:unauth_person) { create :person }

      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
        visit new_comcast_eod_path
      end

      it 'shows the You are not authorized page' do
        expect(page).to have_content('Your access does not allow you to view this page')
      end
    end
  end

end