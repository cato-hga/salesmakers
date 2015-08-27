require 'rails_helper'

describe 'Sprint Sale Entry' do
  let(:unauth_person) { create :person }
  let!(:sprint_employee_one) { create :person, position: position, display_name: 'Employee One' }
  let(:sprint_employee_two) { create :person, position: position, display_name: 'Employee Two' }
  let(:sprint_manager) { create :person, position: position, display_name: 'Manager' }
  let(:position) { create :position, permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'sprint_sale_create',
                                           permission_group: permission_group,
                                           description: 'Test Description'
  }
  let(:sprint_retail) { create :project, name: "Sprint Retail" }
  let(:area) { create :area, project: sprint_retail }
  let(:location) { create :location }
  let!(:location_area) { create :location_area,
                                location: location,
                                area: sprint_employee_one_area.area }
  let!(:sprint_employee_one_area) { create :person_area, person: sprint_employee_one, area: area }
  let!(:sprint_employee_two_area) { create :person_area, person: sprint_employee_two, area: area }
  let!(:sprint_manager_area) { create :person_area, person: sprint_manager, area: area, manages: true }
  let(:sprint_sale) { create :sprint_sale }

  describe 'for unauthorized users' do
    it 'shows the You are not authorized page' do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_sprint_sales_path(sprint_retail)
      expect(page).to have_content 'Your access does not allow you to view this page'
    end
  end

  describe 'Prepaid' do
    describe 'for authorized users' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(sprint_employee_one.email)
        visit new_sprint_sales_path(sprint_retail)
      end

      it 'shows the Sprint Prepaid Sale Entry page' do
        expect(page).to have_content 'Sprint Prepaid Sale Entry'
      end
    end

    describe 'form submission' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(sprint_employee_one.email)
        visit new_sprint_sales_path(sprint_retail)
      end

      context 'with all blank data' do
        it 'renders :new_prepaid and shows all relevant error messages' do
          click_on 'Complete Sale'
          expect(page).to have_content "Sale date can't be blank"
          expect(page).to have_content "Person can't be blank"
          expect(page).to have_content "Person can't be blank"
          expect(page).to have_content "Mobile phone can't be blank"
          expect(page).to have_content "Carrier name can't be blank"
          expect(page).to have_content "Handset model name can't be blank"
          expect(page).to have_content "Meid must be 18 characters in length"
          expect(page).to have_content "Upgrade can't be blank"
          expect(page).to have_content "Rate plan name can't be blank"
          expect(page).to have_content "Top up card purchased can't be blank"
          expect(page).to have_content "Phone activated in store can't be blank"
          expect(page).to have_content "Picture with customer can't be blank"
        end
      end

      context 'has select options for' do
        it 'Sales Representative' do
          expect(page).to have_select 'sprint_sale_person_id', text: sprint_employee_one.name
        end

        it 'Locations' do
          expect(page).to have_select 'sprint_sale_location_id', text: location.name
        end

        it 'New Service?' do
          expect(page).to have_select 'sprint_sale_upgrade', text: "New Activation Upgrade"
        end

        it 'Was a Top-Up Card purchased?' do
          expect(page).to have_select 'sprint_sale_top_up_card_purchased', text: "Yes No"
        end

        it 'Was the phone activated in-store?' do
          expect(page).to have_select 'sprint_sale_phone_activated_in_store', text: "Yes No"
        end

        it 'Did you get a picture with customer?' do
          expect(page).to have_select 'sprint_sale_picture_with_customer', text: "Yes No, Customer refused No, Forgot"
        end
      end

      context 'Sprint sales rep' do
        it 'can select their name and the names of the employees they manage' do
          expect(page).to have_select 'sprint_sale_person_id', text: sprint_employee_one.display_name
          expect(page).not_to have_select 'sprint_sale_person_id', text: sprint_employee_two.display_name
        end
      end
    end

    describe 'sprint manager' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(sprint_manager.email)
        visit new_sprint_sales_path(sprint_retail)
      end

      it 'can select their name and the names of the employees they manage' do
        expect(page).to have_select 'sprint_sale_person_id', text: sprint_manager.display_name
        expect(page).to have_select 'sprint_sale_person_id', text: sprint_employee_one.display_name
        expect(page).to have_select 'sprint_sale_person_id', text: sprint_employee_two.display_name
      end
    end

    describe 'sprint person with all field visibility' do
      let(:sprint_person_with_all_visibility) { create :person, position: position_with_all_visibility }
      let(:position_with_all_visibility) { create :position,
                                                  permissions: [permission_create],
                                                  all_field_visibility: true }
      let(:other_location) { create :location,
                                    display_name: '35th St. N',
                                    store_number: 'DCWM4690',
                                    city: 'Orlando',
                                    state: 'FL',
                                    street_1: '555 35th St N' }
      let!(:other_location_area) { create :location_area,
                                         location: other_location,
                                         area: all_visibility_area.area }
      let(:all_visibility_area) { create :person_area, person: sprint_person_with_all_visibility, area: area }

      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(sprint_person_with_all_visibility.email)
        visit new_sprint_sales_path(sprint_retail)
      end

      it 'can select from all sprint locations' do
        expect(page).to have_select 'sprint_sale_location_id', text: location.name
        expect(page).to have_select 'sprint_sale_location_id', text: other_location.name
      end
    end
  end
end

