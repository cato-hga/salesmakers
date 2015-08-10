require 'rails_helper'

describe 'Comcast lead destruction' do
  let(:department) { create :department }
  let(:position) { create :comcast_sales_position, department: department }
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

  describe 'for authorized employees' do
    let(:position) { create :comcast_sales_position, permissions: [permission_customer_index] }
    let(:comcast_customer) { create :comcast_customer, person: comcast_employee }
    let!(:comcast_lead) {
      create :comcast_lead,
             follow_up_by: Date.tomorrow,
             comcast_customer: comcast_customer
    }

    let(:comcast_employee) { create :comcast_employee, position: position }
    let!(:reason) { create :comcast_lead_dismissal_reason }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(comcast_employee.email)
      visit comcast_customer_path(comcast_customer)
      within '#comcast_lead' do
        click_on 'Dismiss Lead'
      end
    end

    specify 'the dismiss button takes you to a dismiss screen' do
      expect(current_path).to eq(dismiss_comcast_customer_comcast_lead_path(comcast_customer, comcast_lead))
    end

    it 'contains a form for comments and selecting a dismissal reason' do
      expect(page).to have_content 'Dismiss ' + comcast_customer.name
      expect(page).to have_content 'Dismissal reason'
      expect(page).to have_content 'Comments'
    end

    it 'deactivates a lead' do
      expect(comcast_customer.comcast_lead_dismissal_reason_id).to be_nil
      expect(comcast_customer.dismissal_comment).to be_nil
      select 'Test Reason'
      fill_in 'Comments', with: 'Test Comments!'
      click_on 'Dismiss'
      expect(page).to have_content('dismissed')
      expect(page).to have_content('My Leads')
      comcast_customer.reload
      expect(comcast_customer.comcast_lead_dismissal_reason_id).to eq(reason.id)
      expect(comcast_customer.dismissal_comment).to eq('Test Comments!')
    end

    it 'will flash an error message if dismissal reason is left blank' do
      expect(comcast_customer.comcast_lead_dismissal_reason_id).to be_nil
      click_on 'Dismiss'
      expect(page).to have_content('Comcast Lead Dismissal reason is required')
    end

    context 'an inactive lead' do
      let!(:inactive_lead) { create :comcast_lead,
                                    comcast_customer: comcast_customer,
                                    active: false
      }


      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(comcast_employee.email)
        visit comcast_customer_path(comcast_customer)
      end
      it 'displays dismissal reason on show page' do
        expect(page).to have_content('Lead Details')
        expect(page).to have_selector('strong', text: comcast_customer.comcast_lead_dismissal_reason)
      end
      it 'does not show dismissal or reassign button if lead is inactive' do
        expect(page).not_to have_button 'Dismiss Lead'
        expect(page).not_to have_button 'Reassign Lead'
      end
    end
  end
end