require 'rails_helper'

describe 'Sprint Sale Entry' do
  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }
    let(:prepaid_project) { create :project, name: "Sprint Prepaid" }
    let(:star_project) { create :project, name: "STAR" }

    it 'shows the You are not authorized page when trying to access the prepaid sale page' do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_sprint_sales_path(prepaid_project)
      expect(page).to have_content 'Your access does not allow you to view this page'
    end

    it 'shows the You are not authorized page when trying to access the star sale page' do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_sprint_sales_path(star_project)
      expect(page).to have_content 'Your access does not allow you to view this page'
    end
  end

  describe 'for Prepaid' do
    let!(:sprint_prepaid_employee) { create :person, position: position, display_name: 'Employee One' }
    let(:sprint_prepaid_employee_two) { create :person, position: position, display_name: 'Employee Two' }
    let(:sprint_prepaid_manger) { create :person, position: position, display_name: 'Manager' }
    let(:position) { create :position, permissions: [permission_create] }
    let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
    let(:permission_create) { Permission.new key: 'sprint_sale_create',
                                             permission_group: permission_group,
                                             description: 'Test Description'
    }
    let!(:sprint_prepaid) { create :project, name: "Sprint Prepaid", sprint_carriers: [sprint_prepaid_carrier] }
    let!(:star) { create :project, name: "STAR" }
    let(:area) { create :area, project: sprint_prepaid }
    let(:location) { create :location }
    let!(:location_area) { create :location_area,
                                  location: location,
                                  area: sprint_prepaid_employee_area.area }
    let!(:sprint_prepaid_employee_area) { create :person_area, person: sprint_prepaid_employee, area: area }
    let!(:sprint_prepaid_employee_two_area) { create :person_area, person: sprint_prepaid_employee_two, area: area }
    let!(:sprint_prepaid_manger_area) { create :person_area, person: sprint_prepaid_manger, area: area, manages: true }
    let(:sprint_prepaid_sale) { create :sprint_sale, project: sprint_prepaid,
                                      sprint_carrier_id: sprint_prepaid_carrier,
                                      sprint_handset_id: sprint_prepaid_handset,
                                      sprint_rate_plan_id: sprint_prepaid_rate_plan }
    let(:sprint_prepaid_carrier) { create :sprint_carrier,
                                         sprint_handsets: [sprint_prepaid_handset],
                                         sprint_rate_plans: [sprint_prepaid_rate_plan] }
    let(:sprint_prepaid_handset) { create :sprint_handset }
    let(:sprint_prepaid_rate_plan) { create :sprint_rate_plan }

    describe 'form submission' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(sprint_prepaid_employee.email)
        visit new_sprint_sales_path(sprint_prepaid)
      end

      describe 'for authorized users' do
        it 'shows the Sprint Prepaid Sale Entry page' do
          expect(page).to have_content 'Sprint Prepaid Sale Entry'
        end

        context 'with all blank data' do
          it 'renders :new_prepaid and shows all relevant error messages' do
            click_on 'Complete Sale'
            expect(page).to have_content "Person can't be blank"
            expect(page).to have_content "Sale date can't be blank"
            expect(page).to have_content "Location can't be blank"
            expect(page).to have_content "Meid can't be blank"
            expect(page).to have_content "Mobile phone can't be blank"
            expect(page).to have_content "or New Activation must be chosen"
            expect(page).to have_content "Sprint carrier can't be blank"
            expect(page).to have_content "Sprint handset can't be blank"
            expect(page).to have_content "Sprint rate plan can't be blank"
            expect(page).to have_content "Top up card purchased can't be blank"
            expect(page).to have_content "Phone activated in store can't be blank"
            expect(page).to have_content "Picture with customer can't be blank"
          end

          it 'does not show error messages related to star' do
            click_on 'Complete Sale'
            expect(page).not_to have_content "Number of accessories can't be blank"
          end
        end

        context 'with incorrect data' do
          subject {
            fill_in 'Sale Date', with: 32.days.ago
            fill_in 'MEID', with: '12345678901234567'
            fill_in 'Re-enter MEID to Confirm', with: '12345678901234566'
            select 'Yes', from: 'Was a Top-Up Card purchased?'
            select 'No', from: 'Was the phone activated in-store?'
            click_on 'Complete Sale'
          }

          it 'renders :new_prepaid and displays a clear error message' do
            subject
            expect(page).to have_content "Meid must be 18 numbers in length"
            expect(page).to have_content "Meid confirmation doesn't match Meid"
            expect(page).to have_content "Top up card amount can't be blank"
            expect(page).to have_content "Reason not activated in store can't be blank"
            expect(page).to have_content "Sale date cannot be dated for more than 1 month in the past"
          end
        end

        context 'has select options for' do
          it 'Sales Representative' do
            expect(page).to have_select 'sprint_sale_person_id', text: sprint_prepaid_employee.name
          end

          it 'Locations' do
            expect(page).to have_select 'sprint_sale_location_id', text: location.name
          end

          it 'New Service?' do
            expect(page).to have_select 'sprint_sale_upgrade', text: "New Activation Upgrade"
          end

          it 'Product' do
            expect(page).to have_select 'sprint_sale_sprint_carrier_id', text: sprint_prepaid_carrier.name
          end

          it 'Handset' do
            expect(page).to have_select 'sprint_sale_sprint_handset_id', text: sprint_prepaid_handset.name
          end

          it 'Rate Plan' do
            expect(page).to have_select 'sprint_sale_sprint_rate_plan_id', text: sprint_prepaid_rate_plan.name
          end

          it 'Was a Top-Up Card purchased?' do
            expect(page).to have_select 'sprint_sale_top_up_card_purchased', text: "Yes No"
          end

          it 'Was the phone activated in-store?' do
            expect(page).to have_select 'sprint_sale_phone_activated_in_store', text: "Yes No"
          end

          it 'Did you get a picture with customer?' do
            expect(page).to have_select 'sprint_sale_picture_with_customer', text: "Yes No, Customer Refused No, Forgot"
          end
        end

        context 'with all correct data' do
          subject {
            select sprint_prepaid_employee.display_name, from: 'Sales Representative'
            fill_in 'Sale Date', with: Date.yesterday.strftime('%m/%d/%Y')
            select location.name, from: 'Location'
            fill_in 'MEID', with: '123456789012345678'
            fill_in 'Re-enter MEID to Confirm', with: '123456789012345678'
            fill_in 'Mobile Phone Number', with: '55555555555'
            select 'Upgrade', from: 'New Service'
            select sprint_prepaid_carrier.name, from: 'Product'
            select sprint_prepaid_handset.name, from: 'Handset'
            select sprint_prepaid_rate_plan.name, from: 'Rate Plan'
            select 'No', from: 'Was a Top-Up Card purchased?'
            select 'Yes', from: 'Was the phone activated in-store?'
            select 'Yes', from: 'Did you get a picture with customer?'
            click_on 'Complete Sale'
          }

          it 'successfully creates a sprint sale' do
            subject
            expect(page).to have_content 'Sprint Sale has been successfully created.'
          end

          it 'raises the SprintSale count by 1' do
            expect { subject }.to change(SprintSale, :count).by(1)
          end
        end

        context 'Sprint sales rep' do
          it 'can select their name and the names of the employees they manage' do
            expect(page).to have_select 'sprint_sale_person_id', text: sprint_prepaid_employee.display_name
            expect(page).not_to have_select 'sprint_sale_person_id', text: sprint_prepaid_employee_two.display_name
          end
        end
      end

      describe 'sprint manager' do
        before(:each) do
          CASClient::Frameworks::Rails::Filter.fake(sprint_prepaid_manger.email)
          visit new_sprint_sales_path(sprint_prepaid)
        end

        it 'can select their name and the names of the employees they manage' do
          expect(page).to have_select 'sprint_sale_person_id', text: sprint_prepaid_manger.display_name
          expect(page).to have_select 'sprint_sale_person_id', text: sprint_prepaid_employee.display_name
          expect(page).to have_select 'sprint_sale_person_id', text: sprint_prepaid_employee_two.display_name
        end
      end

      describe 'prepaid person with all field visibility' do
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
          visit new_sprint_sales_path(sprint_prepaid)
        end

        it 'can select from all sprint locations' do
          expect(page).to have_select 'sprint_sale_location_id', text: location.name
          expect(page).to have_select 'sprint_sale_location_id', text: other_location.name
        end
      end
    end
  end

  describe 'for Postpaid' do
    let(:star_employee) { create :person, position: position, display_name: 'Employee One' }
    let(:star_employee_two) { create :person, position: position, display_name: 'Employee Two' }
    let(:star_manager) { create :person, position: position, display_name: 'Manager' }
    let(:position) { create :position, permissions: [permission_create] }
    let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
    let(:permission_create) { Permission.new key: 'sprint_sale_create',
                                             permission_group: permission_group,
                                             description: 'Test Description'
    }
    let!(:star) { create :project, name: "STAR", sprint_carriers: [star_carrier] }
    let!(:sprint_prepaid) { create :project, name: "Sprint Prepaid" }
    let(:star_area) { create :area, project: star }
    let!(:star_employee_area) { create :person_area, person: star_employee, area: star_area }
    let!(:star_employee_two_area) { create :person_area, person: star_employee_two, area: star_area }
    let!(:star_manager_area) { create :person_area, person: star_manager, area: star_area, manages: true }
    let(:sprint_location) { create :location }
    let!(:location_area) { create :location_area,
                                  location: sprint_location,
                                  area: star_employee_area.area }
    let(:star_sale) { create :sprint_sale, project: star,
                                      sprint_handset_id: star_handset,
                                      sprint_rate_plan_id: star_rate_plan }
    let(:star_carrier) { create :sprint_carrier, name: 'Sprint',
                                           sprint_handsets: [star_handset],
                                           sprint_rate_plans: [star_rate_plan] }
    let(:star_handset) { create :sprint_handset, name: 'Apple iPhone 6 Plus' }
    let(:star_rate_plan) { create :sprint_rate_plan, name: 'Easy Pay' }

    describe 'form submission' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(star_employee.email)
        visit new_sprint_sales_path(star)
      end

      describe 'authorized users' do
        it 'shows the STAR Sale Entry page' do
          expect(page).to have_content 'STAR Sale Entry'
        end

        context 'with all blank data' do
          it 'renders :new_star and shows all relevant error messages' do
            click_on 'Complete Sale'
            expect(page).to have_content "Sale date can't be blank"
            expect(page).to have_content "Person can't be blank"
            expect(page).to have_content "Location can't be blank"
            expect(page).to have_content "Sprint handset can't be blank"
            expect(page).to have_content "or New Activation must be chosen"
            expect(page).to have_content "Sprint rate plan can't be blank"
            expect(page).to have_content "Number of accessories can't be blank"
            expect(page).to have_content "Picture with customer can't be blank"
          end

          it 'does not show error messages related to prepaid' do
            click_on 'Complete Sale'
            expect(page).not_to have_content "Mobile phone can't be blank"
            expect(page).to_not have_content "Carrier name can't be blank"
            expect(page).not_to have_content "Meid can't be blank"
            expect(page).not_to have_content "Top up card purchased can't be blank"
            expect(page).not_to have_content "Phone activated in store can't be blank"
          end
        end

        context 'with incorrect data' do
          subject {
            fill_in 'Sale Date', with: 32.days.ago
            click_on 'Complete Sale'
          }

          it 'renders :new_star and displays a clear error message' do
            subject
            expect(page).to have_content "Sale date cannot be dated for more than 1 month in the past"
          end
        end

        context 'has select options for' do
          it 'Sales Representative' do
            expect(page).to have_select 'sprint_sale_person_id', text: star_employee.name
          end

          it 'Locations' do
            expect(page).to have_select 'sprint_sale_location_id', text: sprint_location.name
          end

          it 'New Service?' do
            expect(page).to have_select 'sprint_sale_upgrade', text: "New Activation Upgrade"
          end

          it 'Handset' do
            expect(page).to have_select 'sprint_sale_sprint_handset_id', text: star_handset.name
          end

          it 'Rate Plan' do
            expect(page).to have_select 'sprint_sale_sprint_rate_plan_id', text: star_rate_plan.name
          end

          it 'Did you get a picture with customer?' do
            expect(page).to have_select 'sprint_sale_picture_with_customer', text: "Yes No, Customer Refused No, Forgot"
          end
        end

        context 'with all correct data' do
          subject {
            select star_employee.display_name, from: 'Sales Representative'
            fill_in 'Sale Date', with: Date.yesterday.strftime('%m/%d/%Y')
            select sprint_location.name, from: 'Location'
            select 'Upgrade', from: 'New Service'
            select star_handset.name, from: 'Handset'
            select star_rate_plan.name, from: 'Rate Plan'
            fill_in 'Number of accessories', with: 1
            select 'Yes', from: 'Did you get a picture with customer?'
            click_on 'Complete Sale'
          }

          it 'successfully creates a sprint Postpaid sale' do
            subject
            expect(page).to have_content 'Sprint Sale has been successfully created.'
          end

          it 'raises the SprintSale count by 1' do
            expect { subject }.to change(SprintSale, :count).by(1)
          end
        end

        context 'Sprint sales rep' do
          it 'can select their name and the names of the employees they manage' do
            expect(page).to have_select 'sprint_sale_person_id', text: star_employee.display_name
            expect(page).not_to have_select 'sprint_sale_person_id', text: star_employee_two.display_name
          end
        end
      end

      describe 'sprint manager' do
        before(:each) do
          CASClient::Frameworks::Rails::Filter.fake(star_manager.email)
          visit new_sprint_sales_path(star)
        end

        it 'can select their name and the names of the employees they manage' do
          expect(page).to have_select 'sprint_sale_person_id', text: star_manager.display_name
          expect(page).to have_select 'sprint_sale_person_id', text: star_employee.display_name
          expect(page).to have_select 'sprint_sale_person_id', text: star_employee_two.display_name
        end
      end

      describe 'star person with all field visibility' do
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
        let(:all_visibility_area) { create :person_area, person: sprint_person_with_all_visibility, area: star_area }

        before(:each) do
          CASClient::Frameworks::Rails::Filter.fake(sprint_person_with_all_visibility.email)
          visit new_sprint_sales_path(star)
        end

        it 'can select from all sprint locations' do
          expect(page).to have_select 'sprint_sale_location_id', text: sprint_location.name
          expect(page).to have_select 'sprint_sale_location_id', text: other_location.name
        end
      end
    end
  end
end