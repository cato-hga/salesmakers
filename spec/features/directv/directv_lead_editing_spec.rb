require 'rails_helper'

describe 'DirecTV lead editing' do
  let(:position) { create :directv_sales_position, permissions: [permission_customer_index] }
  let(:directv_customer) { create :directv_customer, person: directv_employee }
  let!(:directv_lead) { create :directv_lead, directv_customer: directv_customer }
  let!(:directv_employee) { create :directv_employee, position: position }
  let(:permission_group) { PermissionGroup.create name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_customer_index) { Permission.create key: 'directv_customer_index', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.create key: 'directv_customer_update', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.create key: 'directv_customer_destroy', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.create key: 'directv_customer_create', permission_group: permission_group, description: description }
  let!(:location) { create :location, display_name: 'New Location' }
  let(:project) { create :project, name: 'DirecTV Retail' }
  let(:person_area) { create :person_area,
                             person: directv_employee,
                             area: create(:area,
                                          project: project) }
  let!(:location_area) { create :location_area,
                                location: location,
                                area: person_area.area }

  describe 'for unauthorized employees' do
    context 'that are from other projects' do
      let(:unauth_person) { create :person }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
        visit directv_customer_path(directv_customer)
      end

      it 'does not show the edit lead button' do
        expect(page).not_to have_content('Edit Lead')
      end
    end

    context 'that are not the person attached to the customer/lead' do
      let(:position) { create :directv_sales_position }
      let(:directv_customer) { create :directv_customer, person: directv_employee }
      let!(:directv_lead) {
        create :directv_lead,
               directv_customer: directv_customer
      }
      let!(:unauth_person) { create :directv_employee, email: 'anotherdirectvrep@cc.salesmakersinc.com', position: position }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
        visit directv_customer_path(directv_customer)
      end

      it 'does not show the edit lead button' do
        expect(page).not_to have_content('Edit Lead')
      end
    end
  end

  describe 'for authorized employees' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(directv_employee.email)
      visit directv_customer_path(directv_customer)
      click_on 'Edit Lead'
    end

    describe 'form' do
      it 'shows the edit form and all fields' do
        expect(page).to have_content('Edit Lead')
        expect(page).to have_content('Follow up by')
        expect(page).to have_content('Customer agrees to be contacted by phone or text message')
        expect(page).to have_content('Location')
        expect(page).to have_content('First name')
        expect(page).to have_content('Last name')
        expect(page).to have_content('Mobile phone')
        expect(page).to have_content('Other phone')
      end
    end

    describe 'submission success' do
      before do
        fill_in 'Follow up by', with: (Date.today + 1.week).strftime('%m/%d/%Y')
        fill_in 'Comments', with: 'Test Comment'
        select location.name, from: 'Location'
        fill_in 'First name', with: 'Peter'
        fill_in 'Last name', with: 'Ortiz'
        fill_in 'Mobile phone', with: '7777777777'
        fill_in 'Other phone', with: '8888888888'
        click_on 'Save as Lead'
      end

      it 'flashes a success message' do
        expect(page).to have_content('Lead updated')
      end

      it 'redirects to the DirecTV Customers path' do
        expect(page).to have_content('My Leads')
      end

      it 'updates the lead' do
        directv_customer.reload
        expect(page).to have_content((Date.today + 1.week).strftime('%m/%d/%Y'))
        expect(directv_customer.location).to eq(location)
        click_on('Peter Ortiz')
        expect(page).to have_content('Peter')
        expect(page).to have_content('Ortiz')
        expect(page).to have_content('(777) 777-7777')
        expect(page).to have_content('(888) 888-8888')
      end
    end

    describe 'submission failure' do
      before do
        uncheck 'Customer agrees to be contacted by phone or text message'
        click_on 'Save as Lead'
      end

      it 'flashes error messages' do
        expect(page).to have_content('Lead could not be updated')
      end

      it 'renders the edit page again' do
        expect(page).to have_content('Edit Lead')
      end
    end
  end
end