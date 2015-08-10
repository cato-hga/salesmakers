require 'rails_helper'

describe 'Editing Candidates' do

  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.create key: 'candidate_index',
                                             description: 'Blah blah blah',
                                             permission_group: permission_group }
  let!(:candidate) { create :candidate }

  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit candidate_path candidate
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      visit candidate_path candidate
      within('#basic_information') do
        click_on 'Edit'
      end
    end

    it 'shows the Edit form' do
      expect(page).to have_content('Edit Candidate')
    end

    context 'the edit form' do
      it 'contains all fields' do
        within '#content' do
          expect(page).to have_content('First name')
          expect(page).to have_content('Last name')
          expect(page).to have_content('Suffix')
          expect(page).to have_content('Mobile phone')
          expect(page).to have_content('Email address')
          expect(page).to have_content('Zip Code')
          expect(page).to have_content('Candidate source')
        end
      end

      it 'does not show the prescreen or left voicemail buttons' do
        expect(page).not_to have_button 'Save and start Prescreen'
        expect(page).not_to have_content 'Save, left voicemail'
      end
      it 'does show the save button' do
        expect(page).to have_button 'Save Candidate'
      end
    end

    describe 'form submission' do
      context 'with invalid data' do
        before(:each) do
          within '#content' do
            fill_in 'First name', with: ''
            click_on 'Save Candidate'
          end
        end
        it 'shows all relevant error messages' do
          expect(page).to have_content 'Candidate could not be saved:'
          expect(page).to have_content "First name can't be blank"
        end
        it 'renders candidate#edit' do
          expect(page).to have_content 'Edit Candidate'
        end
      end

      context 'with valid data' do
        before(:each) do
          within '#content' do
            fill_in 'First name', with: 'Acorrectfirst'
            click_on 'Save Candidate'
          end
        end
        it 'updates the candidate' do
          candidate.reload
          expect(candidate.first_name).to eq('Acorrectfirst')
        end
        it 'redirects to candidate#show' do
          expect(page).to have_content('Basic Information')
          expect(page).to have_content('Progress')
        end
        it 'creates a log entry' do
          expect(LogEntry.count).to eq(1)
        end
        it 'flashes a success action' do
          expect(page).to have_content('Candidate updated')
        end
      end
    end
  end
end