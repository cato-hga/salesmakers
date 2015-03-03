require 'rails_helper'
describe 'Candidate creation' do
  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:location) { create :location }
  let(:project) { create :project, name: 'Comcast Retail' }

  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_candidate_path
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      visit new_candidate_path
    end
    it 'has the new candidate form with all fields' do
      expect(page).to have_content('First name')
      expect(page).to have_content('Last name')
      expect(page).to have_content('Suffix')
      expect(page).to have_content('Mobile phone')
      expect(page).to have_content('Email address')
      expect(page).to have_content('Zip Code')
      expect(page).to have_content('Project recruited for')
      expect(page).to have_button 'Save and start Prescreen'
    end


    describe 'form submission' do
      context 'with invalid data' do
        it 'shows all relevant error messages' do
          click_on 'Save and start Prescreen'
          expect(page).to have_content "First name can't be blank"
          expect(page).to have_content "Last name can't be blank"
          expect(page).to have_content "Mobile phone can't be blank"
          expect(page).to have_content "Email can't be blank"
          expect(page).to have_content "Zip can't be blank"
          expect(page).to have_content "Project can't be blank"
        end
      end
      context 'with valid data' do
        it 'displays a flash message', pending: 'Needs Prescreen page'
        it 'redirects to the prescreen questions page', pending: 'Needs Prescreen page'
      end
    end
  end
end