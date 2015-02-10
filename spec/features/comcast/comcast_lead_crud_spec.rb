require 'rails_helper'

describe 'Comcast lead CRUD actions' do
  let(:position) { create :comcast_sales_position }
  let(:comcast_customer) { create :comcast_customer, person: comcast_employee }
  let!(:comcast_lead) {
    build :comcast_lead,
          comcast_customer: comcast_customer
  }
  let!(:comcast_employee) { create :comcast_employee, position: position }

  let(:permission_group) { PermissionGroup.create name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_customer_index) { Permission.create key: 'comcast_customer_index', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.create key: 'comcast_lead_update', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.create key: 'comcast_lead_destroy', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.create key: 'comcast_lead_create', permission_group: permission_group, description: description }

  before do
    CASClient::Frameworks::Rails::Filter.fake(comcast_employee.email)
  end

  context 'for destruction', js: true do
    before do
      comcast_employee.position.permissions << permission_destroy
      comcast_employee.position.permissions << permission_customer_index
      comcast_lead.save
    end

    it 'deactivates a lead' do
      visit comcast_customer_path(comcast_customer)
      page.driver.browser.accept_js_confirms
      within '#comcast_lead' do
        click_on 'Dismiss Lead'
      end
      expect(page).to have_content('dismissed')
      expect(page).to have_content('My Leads')
    end

  end
end