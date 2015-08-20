require 'rails_helper'

describe 'Vonage Sale entry' do
  let(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'vonage_sale_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:location) { create :location }
  let(:project) { create :project, name: 'Vonage Retail' }
  let(:person_area) { create :person_area,
                             person: person,
                             area: create(:area,
                                          project: project) }
  let!(:location_area) { create :location_area,
                                location: location,
                                area: person_area.area }

  describe 'new page' do
    context 'for unauthorized users' do
      let(:unauth_person) { create :person }

      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
        visit new_vonage_sale_path
      end

      it 'shows the You are not authorized page' do
        expect(page).to have_content('Your access does not allow you to view this page')
      end
    end

    context 'for authorized users' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit new_vonage_sale_path
      end

      it 'shows the Vonage Sale Entry page' do
        expect(page).to have_content('Vonage Sale Entry')
      end
    end
  end



  describe 'form submission' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit new_vonage_sale_path
    end

    context 'with all blank data' do
      it 'renders :new and shows all relevant error messages' do
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
  end
end