require 'rails_helper'
describe 'Candidate creation' do
  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'candidate_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let(:location) { create :location }
  let!(:project) { create :project, name: 'Comcast Retail' }
  let!(:source) { create :candidate_source }

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
      expect(page).to have_content('Candidate source')
      expect(page).to have_button 'Save and start Prescreen'
      expect(page).to have_content 'Save, left voicemail'
    end

    describe 'form submission' do
      context 'with invalid data' do
        it 'shows all relevant error messages' do
          click_on 'Save and start Prescreen'
          expect(page).to have_content "First name can't be blank"
          expect(page).to have_content "Last name can't be blank"
          expect(page).to have_content "Mobile phone can't be blank"
          expect(page).to have_content "Email can't be blank"
          expect(page).to have_content "Zip is the wrong length"
        end

      end
      context 'with valid data' do
        before(:each) do
          fill_in 'First name', with: 'Test'
          fill_in 'Last name', with: 'Candidate'
          fill_in 'Mobile phone', with: '727-498-5180'
          fill_in 'Email address', with: 'test@test.com'
          fill_in 'Zip Code', with: '33701'
          select source.name, from: 'Candidate source'
          click_on 'Save and start Prescreen'
        end

        context 'and leaving voicemail' do
          before(:each) do
            fill_in 'First name', with: 'Test'
            fill_in 'Last name', with: 'Candidate'
            fill_in 'Mobile phone', with: '727-498-5180'
            fill_in 'Email address', with: 'test@test.com'
            fill_in 'Zip Code', with: '33701'
            select project.name, from: 'Project recruited for'
            select source.name, from: 'Candidate source'
            find(:xpath, "//input[@id='start_prescreen']").set false
            click_on 'Save and start Prescreen'
          end
          it 'displays a flash message' do
            expect(page).to have_content 'Candidate saved!'
          end
          it 'redirects to the candidate index' do
            expect(page).to have_content 'Candidates'
            within('header h1') do
              expect(page).not_to have_content 'Prescreen Answers'
            end
          end
          it "creates an outbound contact log, with a note 'Left Voicemail'" do
            candidate = Candidate.first
            visit candidate_path candidate
            expect(page).to have_content 'Left Voicemail'
          end
          it 'sets the candidate contact datetime correctly' do
            expect(CandidateContact.first.created_at).to be_within((2).second).of(Time.now)
            candidate = Candidate.first
            visit candidate_path candidate
            expect(page).to have_content Time.zone.now.strftime('%l:%M%P %Z')
          end
        end
      end
    end
  end
end
