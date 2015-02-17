require 'rails_helper'

describe 'Comcast lead destruction' do
  let(:position) { create :comcast_sales_position }
  let(:comcast_customer) { create :comcast_customer, person: comcast_employee }
  let!(:comcast_lead) {
    create :comcast_lead,
           comcast_customer: comcast_customer
  }
  let!(:comcast_employee) { create :comcast_employee, position: position }
  let(:permission_group) { PermissionGroup.create name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_customer_index) { Permission.create key: 'comcast_customer_index', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.create key: 'comcast_customer_update', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.create key: 'comcast_customer_destroy', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.create key: 'comcast_customer_create', permission_group: permission_group, description: description }

  describe 'for unauthorized employees' do
    context 'that are from other projects' do
      let(:unauth_person) { create :person }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
        visit comcast_customer_path(comcast_customer)
      end

      it 'does not show the Dismiss lead button' do
        expect(page).not_to have_content('Dismiss Lead')
      end
    end

    context 'that are not the person attached to the customer/lead, or their manager' do
      let(:position) { create :comcast_sales_position }
      let(:comcast_customer) { create :comcast_customer, person: comcast_employee }
      let!(:comcast_lead) {
        create :comcast_lead,
               comcast_customer: comcast_customer
      }
      let!(:unauth_person) { create :comcast_employee, email: 'anothercomcastrep@cc.salesmakersinc.com', position: position }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
        visit comcast_customer_path(comcast_customer)
      end
      it 'does not show the Dismiss lead button' do
        expect(page).not_to have_content('Dismiss Lead')
      end
    end
  end

  describe 'for authorized employees', js: true do
    let(:position) { create :comcast_sales_position, permissions: [permission_customer_index] }
    let(:comcast_customer) { create :comcast_customer, person: comcast_employee }
    let!(:comcast_lead) {
      create :comcast_lead,
             follow_up_by: Date.tomorrow,
             comcast_customer: comcast_customer
    }

    let(:comcast_employee) { create :comcast_employee, position: position }

    it 'deactivates a lead' do
      CASClient::Frameworks::Rails::Filter.fake(comcast_employee.email)
      visit comcast_customer_path(comcast_customer)
      within '#comcast_lead' do
        click_on 'Dismiss Lead'
      end
      expect(page).to have_content('dismissed')
      expect(page).to have_content('My Leads')
    end

  end
end