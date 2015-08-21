require 'rails_helper'

describe 'Vonage Sale entry' do
  let!(:vonage_person_with_all_visibility) { create :person, position: position_with_all_visibility }
  let(:manager) { create :person, position: position, display_name: 'Manager' }
  let!(:employee_one) { create :person, position: position, display_name: 'Employee One' }
  let(:employee_two) { create :person, position: position, display_name: 'Employee Two' }
  let(:unauth_person) { create :person }
  let(:position) { create :position, permissions: [permission_create] }
  let(:position_with_all_visibility) { create :position, permissions: [permission_create], all_field_visibility: true }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'vonage_sale_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:vonage) { create :project, name: 'Vonage Retail' }
  let(:area) { create :area, project: vonage }
  let(:location) { create :location }
  let!(:location_area) { create :location_area,
                                location: location,
                                area: employee_one_area.area }
  let!(:employee_one_area) { create :person_area, person: employee_one, area: area }
  let!(:employee_two_area) { create :person_area, person: employee_two, area: area }
  let!(:manager_area) { create :person_area, person: manager, area: area, manages: true }
  let!(:home_kit) { create :vonage_product, name: 'Vonage Whole Home Kit' }

  subject {
    CASClient::Frameworks::Rails::Filter.fake(employee_one.email)
    visit new_vonage_sale_path
  }

  describe 'new page' do
    context 'for unauthorized users' do
      it 'shows the You are not authorized page' do
        CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
        visit new_vonage_sale_path
        expect(page).to have_content('Your access does not allow you to view this page')
      end
    end

    context 'for authorized users' do
      it 'shows the Vonage Sale Entry page' do
        subject
        expect(page).to have_content('Vonage Sale Entry')
      end
    end
  end

  describe 'form submission' do
    context 'with all blank data' do
      it 'renders :new and shows all relevant error messages' do
        subject
        click_on 'Complete Sale'
        expect(page).to have_content "Sale date can't be blank"
        expect(page).to have_content "Person can't be blank"
        expect(page).to have_content "Confirmation number is the wrong length (should be 10 characters)"
        expect(page).to have_content "Location can't be blank"
        expect(page).to have_content "Customer first name can't be blank"
        expect(page).to have_content "Customer last name can't be blank"
        expect(page).to have_content "Mac is invalid"
        expect(page).to have_content "Vonage product can't be blank"
        expect(page).to have_content "Person acknowledged must be accepted"
      end
    end


    context 'a vonage sales representative' do
      it 'can only select their name' do
        subject
        expect(page).to have_select 'vonage_sale_person_id', text: employee_one.display_name
        expect(page).not_to have_select 'vonage_sale_person_id', text: employee_two.display_name
      end
    end

    context 'a vonage manager' do
      it 'can select their name and the names of the employees they manage' do
        CASClient::Frameworks::Rails::Filter.fake(manager.email)
        visit new_vonage_sale_path
        expect(page).to have_select 'vonage_sale_person_id', text: manager.display_name
        expect(page).to have_select 'vonage_sale_person_id', text: employee_one.display_name
        expect(page).to have_select 'vonage_sale_person_id', text: employee_two.display_name
      end
    end

    context 'vonage person with all field visibility' do
      let(:other_location) { create :location,
                                    display_name: '35th St N',
                                    store_number: 'DCWM4690',
                                    city: 'Orlando',
                                    state: 'FL',
                                    street_1: '555 35th St N' }
      let!(:other_location_area) { create :location_area,
                                          location: other_location,
                                          area: all_visibility_area.area }
      let(:all_visibility_area) { create :person_area, person: vonage_person_with_all_visibility, area: area }

      it 'can select from all vonage locations' do
        CASClient::Frameworks::Rails::Filter.fake(vonage_person_with_all_visibility.email)
        visit new_vonage_sale_path
        expect(page).to have_select 'vonage_sale_location_id', text: location.name
        expect(page).to have_select 'vonage_sale_location_id', text: other_location.name
      end
    end

    it 'has locations to select from' do
      subject
      expect(page).to have_select 'vonage_sale_location_id', text: location.name
    end

    it 'has a vonage product to select from' do
      subject
      expect(page).to have_select 'vonage_sale_vonage_product_id', text: home_kit.name
    end

    context 'Product Type Vonage Whole Home Kit' do
      it 'requires a gift card number' do
        subject
        select employee_one.display_name, from: 'Sales Representative'
        fill_in 'Sale Date', with: '08/15/2015'
        fill_in 'Confirmation Number', with: '1234567890'
        select location.name, from: 'Location'
        fill_in 'Customer First Name', with: 'Test'
        fill_in 'Customer Last Name', with: 'Customer'
        fill_in 'MAC ID', with: 'ABCDEF123456'
        fill_in 'Confirm MAC ID', with: 'ABCDEF123456'
        select home_kit.name, from: 'Product Type'
        fill_in 'Gift Card Number', with: ''
        fill_in 'Confirm Gift Card Number', with: ''
        page.check 'vonage_sale_person_acknowledged'
        click_on 'Complete Sale'
        expect(page).to have_content 'Gift card number must be entered if you have selected the Vonage whole home kit'
      end
    end

    context 'with incorrect data' do
      before(:each) do
        subject
        select employee_one.display_name, from: 'Sales Representative'
        fill_in "Sale Date", with: 2.weeks.ago
        fill_in 'Confirmation Number', with: '123456789'
        select location.name, from: 'Location'
        fill_in 'Customer First Name', with: 'test customer'
        fill_in 'Customer Last Name', with: 'customer test'
        fill_in 'MAC ID', with: 'ABCDEF12345'
        fill_in 'Confirm MAC ID', with: 'ABCDEF123457'
        select home_kit.name, from: 'Product Type'
        fill_in 'Gift Card Number', with: 'ab123456789'
        fill_in 'Confirm Gift Card Number', with: 'ab123456789'
        page.check('vonage_sale_person_acknowledged')
        click_on 'Complete Sale'
      end

      it 'renders :new and displays a clear error message' do
        expect(page).to have_content 'Confirmation number is the wrong length (should be 10 characters)'
        expect(page).to have_content 'Customer first name is invalid'
        expect(page).to have_content 'Customer last name is invalid'
        expect(page).to have_content 'Mac is invalid'
        expect(page).to have_content "Mac confirmation doesn't match Mac"
        expect(page).to have_content 'Gift card number is invalid'
        expect(page).to have_content 'Sale date cannot be dated for more than 2 weeks in the past'
      end
    end

    context 'with all correct data' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(employee_one.email)
        visit new_vonage_sale_path
      end

      subject {
        select employee_one.display_name, from: 'Sales Representative'
        fill_in 'Sale Date', with: '08/15/2015'
        fill_in 'Confirmation Number', with: '1234567890'
        select location.name, from: 'Location'
        fill_in 'Customer First Name', with: 'Test'
        fill_in 'Customer Last Name', with: 'Customer'
        fill_in 'MAC ID', with: 'ABCDEF123456'
        fill_in 'Confirm MAC ID', with: 'ABCDEF123456'
        select home_kit.name, from: 'Product Type'
        fill_in 'Gift Card Number', with: 'ab1234567890'
        fill_in 'Confirm Gift Card Number', with: 'ab1234567890'
        page.check('vonage_sale_person_acknowledged')
        click_on 'Complete Sale'
      }

      it 'successfully creates a vonage sale' do
        subject
        expect(page).to have_content 'Vonage Sale has been successfully created.'
      end

      it 'raises the VonageSale count by 1' do
        expect { subject }.to change(VonageSale, :count).by(1)
      end
    end
  end
end