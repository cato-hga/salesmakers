require 'rails_helper'

describe 'DirecTV Customer Creation' do
  let(:person) { create :directv_employee, position: position }
  let(:position) { create :directv_sales_position, permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'directv_customer_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:location) { create :location }
  let(:project) { create :project, name: 'DirecTV Retail' }
  let(:person_area) { create :person_area,
                             person: person,
                             area: create(:area,
                                          project: project) }
  let!(:location_area) { create :location_area,
                                location: location,
                                area: person_area.area }
  describe 'new page' do

    #Auth or not only - see below for form submissions
    context 'for authorized users' do

      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit new_directv_customer_path
      end

      it 'shows the New customer page' do
        expect(page).to have_content('New DirecTV Customer')
      end

      it 'has locations' do
        expect(page).to have_content(location.name)
      end
    end

    context 'for unauthorized users' do

      let(:unauth_person) { create :person }

      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
        visit new_directv_customer_path
      end

      it 'shows the You are not authorized page' do
        expect(page).to have_content('Your access does not allow you to view this page')
      end

    end
  end

  describe 'form submission' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit new_directv_customer_path
    end

    context 'with all blank data' do
      it 'shows all relevant error messages' do
        click_on 'Enter Sale'
        expect(page).to have_content("First name can't be blank")
        expect(page).to have_content("Last name can't be blank")
        expect(page).to have_content("Mobile phone is required")
      end
    end

    describe 'with valid data' do

      describe 'and choosing to enter a sale' do

        before {
          select location.name, from: 'Location'
          fill_in 'First name', with: 'Test'
          fill_in 'Last name', with: 'User'
          fill_in 'Mobile phone', with: '5555555555'
          fill_in 'Other phone', with: '6666666666'
          fill_in 'Comments', with: 'Test comment!'
          click_on 'Enter Sale'
        }

        it 'redirects to the sale page' do
          expect(page).to have_content('New DirecTV Sale')
        end

        it 'saves the customer and displays a flash message' do
          expect(page).to have_content('Customer saved')
        end
      end

      describe 'and choosing to save as a lead' do
        before {
          select location.name, from: 'Location'
          fill_in 'First name', with: 'Test'
          fill_in 'Last name', with: 'User'
          fill_in 'Mobile phone', with: '5555555555'
          fill_in 'Other phone', with: '6666666666'
          fill_in 'Comments', with: 'Test comment!'
          #Hidden field!
          find(:xpath, "//input[@id='save_as_lead']").set true
          click_on 'Enter Sale'
        }

        it 'redirects to the enter lead page' do
          expect(page).to have_content('New Lead')
        end

        it 'saves the customer and display a flash message' do
          expect(page).to have_content('Customer saved')
        end
      end
    end
  end
end