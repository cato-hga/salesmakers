require 'rails_helper'

describe 'Vonage Sale entry' do
  let(:unauth_person) { create :person }
  let(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'vonage_sale_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:manager) { create :person, position: position, display_name: 'Manager' }
  let!(:employee_one) { create :person, position: position, display_name: 'Employee One' }
  let(:employee_two) { create :person, position: position, display_name: 'Employee Two' }
  let(:area) { create :area, project: vonage }
  let(:vonage) { create :project, name: 'Vonage Retail' }
  let!(:employee_one_area) { create :person_area, person: employee_one, area: area }
  let!(:employee_two_area) { create :person_area, person: employee_two, area: area }
  let!(:manager_area) { create :person_area, person: manager, area: area, manages: true }

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
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit new_vonage_sale_path
        expect(page).to have_content('Vonage Sale Entry')
      end
    end
  end

  describe 'form submission' do
    context 'with all blank data' do
      it 'renders :new and shows all relevant error messages' do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit new_vonage_sale_path
        click_on 'Complete Sale'
        expect(page).to have_content "Sale date can't be blank"
        expect(page).to have_content "Person can't be blank"
        expect(page).to have_content "Confirmation number is the wrong length (should be 10 characters)"
        expect(page).to have_content "Location can't be blank"
        expect(page).to have_content "Customer first name can't be blank"
        expect(page).to have_content "Customer last name can't be blank"
        expect(page).to have_content "Mac is the wrong length (should be 12 characters)"
        expect(page).to have_content "Vonage product can't be blank"
        expect(page).to have_content "Person acknowledged must be accepted"
      end
    end

    context 'a vonage sales representative' do
      it 'will only be able to select their name' do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit new_vonage_sale_path
        expect(page).to have_select 'vonage_sale_person_id', text: person.display_name
        expect(page).not_to have_select 'vonage_sale_person_id', text: employee_one.display_name
      end
    end

    context 'a vonage manager' do
      it 'will be able to select their name and the names of the employees they manage' do
        CASClient::Frameworks::Rails::Filter.fake(manager.email)
        visit new_vonage_sale_path
        expect(page).to have_select 'vonage_sale_person_id', text: manager.display_name
        expect(page).to have_select 'vonage_sale_person_id', text: employee_one.display_name
        expect(page).to have_select 'vonage_sale_person_id', text: employee_two.display_name
      end
    end
  end
end