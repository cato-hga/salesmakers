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

  describe 'for authorized employees' do
    let(:position) { create :directv_sales_position, permissions: [permission_customer_index] }
    let!(:active_lead) {
      create :directv_lead,
             active: true,
             follow_up_by: Date.tomorrow,
             directv_customer: directv_customer
    }
    let!(:reason) { create :directv_lead_dismissal_reason }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(directv_employee.email)
      visit directv_customer_path(directv_customer)
      within '#directv_lead' do
        click_on 'Dismiss Lead'

      end
    end

    specify 'the dismiss button takes you to a dismiss screen' do
      expect(current_path).to eq(dismiss_directv_customer_directv_lead_path(directv_customer, directv_lead))
    end

    it 'contains a form for comments and selecting a dismissal reason' do
      expect(page).to have_content 'Dismiss ' + directv_customer.name
      expect(page).to have_content 'Dismissal reason'
      expect(page).to have_content 'Comments'
    end

    it 'deactivates a lead' do
      expect(directv_customer.directv_lead_dismissal_reason_id).to be_nil
      expect(directv_customer.dismissal_comment).to be_nil
      select 'Test Reason'
      fill_in 'Comments', with: 'Test Comments!'
      click_on 'Dismiss'
      expect(page).to have_content('dismissed')
      expect(page).to have_content('My Leads')
      directv_customer.reload
      expect(directv_customer.directv_lead_dismissal_reason_id).to eq(reason.id)
      expect(directv_customer.dismissal_comment).to eq('Test Comments!')
    end



    context 'an inactive lead' do
      let!(:inactive_lead) { create :directv_lead,
                                   directv_customer: directv_customer,
                                   active: false
      }


      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(directv_employee.email)
        visit directv_customer_path(directv_customer)
      end
      it 'displays dismissal reason on show page' do
        expect(page).to have_content('Lead Details')
        expect(page).to have_selector('strong', text: directv_customer.directv_lead_dismissal_reason)
      end

      it 'does not show dismissal or reassign button if lead is inactive' do
        expect(page).not_to have_button 'Dismiss Lead'
        expect(page).not_to have_button 'Reassign Lead'

      end
    end
  end
end
