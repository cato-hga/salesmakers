require 'rails_helper'

describe 'Dismissing a candidate for schedule reasons' do

  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.create key: 'candidate_index',
                                             description: 'Blah blah blah',
                                             permission_group: permission_group }
  let!(:reason) { create :candidate_denial_reason, name: 'Scheduling Conflict' }
  let!(:candidate) { create :candidate }

  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_candidate_candidate_scheduling_dismissal_path candidate
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      visit select_location_candidate_path(candidate, 'false')
      click_on 'Dismiss Candidate for Schedule Reason'
    end

    it 'prompts for confirmation, and redirects to candidatesschedulingdismissals#new' do
      expect(page).to have_content 'Dismiss Candidate for Schedule Reason'
    end


    describe 'the candidate scheduling dismissal page' do
      it 'contains AM/PM checkbox for every day of the week' do
        expect(page).to have_content 'Monday'
        expect(page).to have_content 'Tuesday'
        expect(page).to have_content 'AM'
        expect(page).to have_content 'PM'
      end

      it 'contains a box for comments' do
        expect(page).to have_content 'Additional Comments'
      end

      context 'form submission success' do
        before(:each) do
          fill_in 'Additional Comments', with: 'Comment'
          click_on 'Save and Dismiss Candidate'
        end
        it 'archives the candidate and sets them to rejected' do
          candidate.reload
          expect(candidate.active).to eq(false)
          expect(candidate.status).to eq('rejected')
        end
        it 'redirects to candidates#index' do
          expect(page).to have_content('Candidates')
        end

        it 'flashes a success message' do
          expect(page).to have_content('Candidate dismissed')
        end
        it 'assigns a denial reason' do
          candidate.reload
          expect(candidate.candidate_denial_reason).to eq(reason)
        end
      end
      context 'form submission failure' do
        before(:each) do
          click_on 'Save and Dismiss Candidate'
        end
        it 'does not archive the candidate' do
          candidate.reload
          expect(candidate.active).to eq(true)
        end
        it 'renders the dismissal page' do
          expect(page).to have_content('Dismiss Candidate for Schedule Reason')
        end
        it 'flashes a error message' do
          expect(page).to have_content("Comment can't be blank")
        end
      end
    end
  end
end