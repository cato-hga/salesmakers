require 'rails_helper'

describe 'DirecTV lead destruction' do
  let(:department) { create :department }
  let(:position) { create :directv_sales_position, department: department }
  let(:directv_customer) { create :directv_customer, person: directv_employee }
  let!(:directv_lead) {
    create :directv_lead,
           directv_customer: directv_customer
  }
  let!(:directv_employee) { create :directv_employee, position: position }
  let(:permission_group) { PermissionGroup.create name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_customer_index) { Permission.create key: 'directv_customer_index', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.create key: 'directv_customer_update', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.create key: 'directv_customer_destroy', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.create key: 'directv_customer_create', permission_group: permission_group, description: description }

  describe 'for unauthorized employees' do
    context 'that are from other projects' do
      let(:unauth_person) { create :person }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
        visit directv_customer_path(directv_customer)
      end

      it 'does not show the Dismiss lead button' do
        expect(page).not_to have_content('Dismiss Lead')
      end
    end

    context 'that are not the person attached to the customer/lead, or their manager' do
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
      it 'does not show the Dismiss lead button' do
        expect(page).not_to have_content('Dismiss Lead')
      end
    end
  end

  describe 'for authorized employees', js: true do
    let(:position) { create :directv_sales_position, permissions: [permission_customer_index] }
    let(:directv_customer) { create :directv_customer, person: directv_employee }
    let!(:directv_lead) {
      create :directv_lead,
             follow_up_by: Date.tomorrow,
             directv_customer: directv_customer
    }

    let(:directv_employee) { create :directv_employee, position: position }

    it 'deactivates a lead' do
      CASClient::Frameworks::Rails::Filter.fake(directv_employee.email)
      visit directv_customer_path(directv_customer)
      within '#directv_lead' do
        click_on 'Dismiss Lead'
      end
      expect(page).to have_content('dismissed')
      expect(page).to have_content('My Leads')
    end
  end
end