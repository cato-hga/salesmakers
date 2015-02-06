require 'rails_helper'

describe 'Comcast Sale creation' do
  let(:person) { create :comcast_employee, position: position }
  let(:position) { create :comcast_sales_position, permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'comcast_customer_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let!(:comcast_customer) { create :comcast_customer, person: person }
  let!(:comcast_install_time_slot) { create :comcast_install_time_slot }
  let!(:inactive_comcast_install_time_slot) { create :comcast_install_time_slot, name: "Inactive", active: false }
  describe 'new page' do
    context 'for authorized users' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit new_comcast_customer_comcast_sale_path comcast_customer.id
      end

      it 'shows the New Comcast Sale page' do
        expect(page).to have_content('New Comcast Sale')
      end

      it 'has locations' do
        expect(page).to have_content(comcast_customer.name)
      end


      it 'should only show active time slots' do
        expect(page).to have_content(comcast_install_time_slot.name)
        expect(page).not_to have_content(inactive_comcast_install_time_slot.name)
      end
    end

    context 'for unauthorized users' do
      let(:unauth_person) { create :person }

      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
        visit new_comcast_customer_path
      end

      it 'shows the You are not authorized page' do
        expect(page).to have_content('Your access does not allow you to view this page')
      end
    end
  end

  describe 'form submission' do

    context 'with all blank data' do
      it 'renders :new and shows all relevant error messages'
    end
    context 'with an invalid date' do
      it 'renders :new and shows a clear error message'
    end
    context 'with other invalid information' do
      it 'renders :new and should retain information' #Error messages handled above
      it 'does not have invalid dates left over'
    end

    describe 'with valid data' do
      it 'flashes a success message'
      it 'redirects to My Customers'
      it 'shows the sale/installation information'
    end

    context 'from comcast lead page' do
      it 'shows the form'
      it 'shows all fields'
      context 'submission failure' do #submission success in the main page - no need to test
        it 'redirects to the new lead page'
        it 'renders errors'
      end
    end

  end


end