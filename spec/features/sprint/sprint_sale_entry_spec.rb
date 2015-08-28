require 'rails_helper'

describe 'Sprint Sale Entry' do
  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }
    let(:prepaid_project) { create :project, name: "Sprint Retail" }
    let(:postpaid_project) { create :project, name: "Sprint Retail" }

    it 'shows the You are not authorized page when trying to access the prepaid sale page' do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_sprint_sales_path(prepaid_project)
      expect(page).to have_content 'Your access does not allow you to view this page'
    end

    it 'shows the You are not authorized page when trying to access the postpaid sale page' do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_sprint_sales_path(postpaid_project)
      expect(page).to have_content 'Your access does not allow you to view this page'
    end
  end

  describe 'for Prepaid' do
    let!(:sprint_retail_employee) { create :person, position: position, display_name: 'Employee One' }
    let(:sprint_retail_employee_two) { create :person, position: position, display_name: 'Employee Two' }
    let(:sprint_retail_manger) { create :person, position: position, display_name: 'Manager' }
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
                                  area: sprint_retail_employee_area.area }
    let!(:sprint_retail_employee_area) { create :person_area, person: sprint_retail_employee, area: area }
    let!(:sprint_retail_employee_two_area) { create :person_area, person: sprint_retail_employee_two, area: area }
    let!(:sprint_retail_manger_area) { create :person_area, person: sprint_retail_manger, area: area, manages: true }
    let(:sprint_sale) { create :sprint_sale }

    describe 'form submission' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(sprint_retail_employee.email)
        visit new_sprint_sales_path(sprint_retail)
      end

      describe 'for authorized users' do
        it 'shows the Sprint Prepaid Sale Entry page' do
          expect(page).to have_content 'Sprint Prepaid Sale Entry'
        end
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
          expect(page).to have_select 'sprint_sale_person_id', text: sprint_retail_employee.name
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
          expect(page).to have_select 'sprint_sale_picture_with_customer', text: "Yes No, Customer Refused No, Forgot"
        end
      end

      context 'Sprint sales rep' do
        it 'can select their name and the names of the employees they manage' do
          expect(page).to have_select 'sprint_sale_person_id', text: sprint_retail_employee.display_name
          expect(page).not_to have_select 'sprint_sale_person_id', text: sprint_retail_employee_two.display_name
        end
      end
    end

    describe 'sprint manager' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(sprint_retail_manger.email)
        visit new_sprint_sales_path(sprint_retail)
      end

      it 'can select their name and the names of the employees they manage' do
        expect(page).to have_select 'sprint_sale_person_id', text: sprint_retail_manger.display_name
        expect(page).to have_select 'sprint_sale_person_id', text: sprint_retail_employee.display_name
        expect(page).to have_select 'sprint_sale_person_id', text: sprint_retail_employee_two.display_name
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
        visit new_sprint_sales_path(sprint_retail)
      end

      it 'can select from all sprint locations' do
        expect(page).to have_select 'sprint_sale_location_id', text: location.name
        expect(page).to have_select 'sprint_sale_location_id', text: other_location.name
      end
    end
  end

  describe 'for Postpaid' do
    let(:postpaid_employee) { create :person, position: position, display_name: 'Employee One' }
    let(:postpaid_employee_two) { create :person, position: position, display_name: 'Employee Two' }
    let(:postpaid_manager) { create :person, position: position, display_name: 'Manager' }
    let(:position) { create :position, permissions: [permission_create] }
    let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
    let(:permission_create) { Permission.new key: 'sprint_sale_create',
                                             permission_group: permission_group,
                                             description: 'Test Description'
    }
    let(:sprint_postpaid) { create :project, name: "Sprint Postpaid" }
    let(:postpaid_area) { create :area, project: sprint_postpaid }
    let!(:postpaid_employee_area) { create :person_area, person: postpaid_employee, area: postpaid_area }
    let!(:postpaid_employee_two_area) { create :person_area, person: postpaid_employee_two, area: postpaid_area }
    let!(:postpaid_manager_area) { create :person_area, person: postpaid_manager, area: postpaid_area, manages: true }
    let(:sprint_location) { create :location }
    let!(:location_area) { create :location_area,
                                  location: sprint_location,
                                  area: postpaid_employee_area.area }
    describe 'form submission' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(postpaid_employee.email)
        visit new_sprint_sales_path(sprint_postpaid)
      end

      describe 'authorized users' do
        it 'shows the Sprint Postpaid Sale Entry page' do
          expect(page).to have_content 'Sprint Postpaid Sale Entry'
        end

        context 'with all blank data' do
          it 'renders :new_postpaid and shows all relevant error messages' do
            click_on 'Complete Sale'
            expect(page).to have_content "Sale date can't be blank"
            expect(page).to have_content "Person can't be blank"
            expect(page).to have_content "Person can't be blank"
            expect(page).to have_content "Handset model name can't be blank"
            expect(page).to have_content "Upgrade can't be blank"
            expect(page).to have_content "Rate plan name can't be blank"
            expect(page).to have_content "Number of accessories can't be blank"
            expect(page).to have_content "Picture with customer can't be blank"
          end
        end

        context 'has select options for' do
          it 'Sales Representative' do
            expect(page).to have_select 'sprint_sale_person_id', text: postpaid_employee.name
          end

          it 'Locations' do
            expect(page).to have_select 'sprint_sale_location_id', text: sprint_location.name
          end

          it 'New Service?' do
            expect(page).to have_select 'sprint_sale_upgrade', text: "New Activation Upgrade/New Phone"
          end

          it 'Did you get a picture with customer?' do
            expect(page).to have_select 'sprint_sale_picture_with_customer', text: "Yes No, Customer Refused No, Forgot"
          end
        end

        context 'Sprint sales rep' do
          it 'can select their name and the names of the employees they manage' do
            expect(page).to have_select 'sprint_sale_person_id', text: postpaid_employee.display_name
            expect(page).not_to have_select 'sprint_sale_person_id', text: postpaid_employee_two.display_name
          end
        end
      end

      describe 'sprint manager' do
        before(:each) do
          CASClient::Frameworks::Rails::Filter.fake(postpaid_manager.email)
          visit new_sprint_sales_path(sprint_postpaid)
        end

        it 'can select their name and the names of the employees they manage' do
          expect(page).to have_select 'sprint_sale_person_id', text: postpaid_manager.display_name
          expect(page).to have_select 'sprint_sale_person_id', text: postpaid_employee.display_name
          expect(page).to have_select 'sprint_sale_person_id', text: postpaid_employee_two.display_name
        end
      end

      describe 'postpaid person with all field visibility' do
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
        let(:all_visibility_area) { create :person_area, person: sprint_person_with_all_visibility, area: postpaid_area }

        before(:each) do
          CASClient::Frameworks::Rails::Filter.fake(sprint_person_with_all_visibility.email)
          visit new_sprint_sales_path(sprint_postpaid)
        end

        it 'can select from all sprint locations' do
          expect(page).to have_select 'sprint_sale_location_id', text: sprint_location.name
          expect(page).to have_select 'sprint_sale_location_id', text: other_location.name
        end
      end
    end
  end
end
