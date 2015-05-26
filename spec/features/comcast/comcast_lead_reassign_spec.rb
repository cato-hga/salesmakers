require 'rails_helper'

describe 'Comcast Lead Reassigning' do
  let(:person) { create :comcast_employee, position: position }
  let(:person_two) { create :comcast_employee, first_name: 'Person', last_name: 'Two', position: position, email: 'test@test.com' }
  let(:not_visible_employee) { create :comcast_employee, first_name: 'Not', last_name: 'Visible', position: position, email: 'test2@test.com' }
  let(:manager) { create :comcast_manager, position: manager_position }

  let(:manager_position) { create :comcast_sales_manager_position, permissions: [permission_index] }
  let(:position) { create :comcast_sales_position }

  let!(:manager_person_area) { create :person_area, person: manager, area: area, manages: true }
  let!(:employee_person_area) { create :person_area, person: person, area: area, manages: false }
  let!(:person_two_person_area) { create :person_area, person: person_two, area: area, manages: false }
  let(:area) { create :area }

  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_index) { Permission.new key: 'comcast_customer_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }

  let!(:comcast_customer) { create :comcast_customer, person: person }
  let!(:comcast_lead) { create :comcast_lead, comcast_customer: comcast_customer }

  describe 'the reassign page' do

    it 'is accessible from the comcast_customer show page' do
      CASClient::Frameworks::Rails::Filter.fake(manager.email)
      visit comcast_customer_path(comcast_customer)
      expect(page).to have_content 'Reassign Lead'
    end

    context 'for unauthorized users' do
      let(:unauth_person) { create :person }

      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
        visit reassign_comcast_customer_comcast_lead_path comcast_customer.id, comcast_lead.id
      end

      it 'shows the You are not authorized page' do
        expect(page).to have_content('Your access does not allow you to view this page')
      end
    end

    context 'for authorized users' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(manager.email)
        visit reassign_comcast_customer_comcast_lead_path comcast_customer.id, comcast_lead.id
      end

      it 'shows the New Lead page' do
        expect(page).to have_content('Reassign Lead')
      end

      it 'contains the employees for a manager, not including the current employee being reassign from' do
        expect(page).to have_content(person_two.name)
        expect(page).not_to have_content(person.name)
      end
      it 'does not contain other employees' do
        expect(page).not_to have_content(not_visible_employee.name)
      end

      it 'contains a button to reassign' do
        expect(page).to have_button 'Reassign Lead to Employee'
      end

      describe 'upon clicking the link' do
        before(:each) do
          within all('td').last do
            click_on 'Reassign Lead to Employee'
          end
          comcast_customer.reload
        end
        it 'reassigns the lead' do
          expect(comcast_customer.person).to eq(person_two)
        end
        it 'creates a log entry' do
          visit person_path person_two
          expect(page).to have_content 'Was reassigned lead ' + comcast_customer.name + ' by ' + manager.display_name
        end
      end
    end
  end
end