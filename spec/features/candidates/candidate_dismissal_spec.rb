require 'rails_helper'
describe 'Candidate dismissal' do

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
  let!(:reason) { create :candidate_denial_reason }

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
      click_on 'Dismiss Candidate'
    end

    it 'prompts for confirmation, and redirects to canidates#dismiss' do
      expect(page).to have_content 'Dismiss Candidate'
    end

    describe 'the candidate dismissal page' do
      it 'contains a denial reason drop-down' do
        expect(page).to have_content 'Candidate denial reason'
      end

      context 'form submission success' do
        before(:each) do
          select reason.name, from: 'Candidate denial reason'
          click_on 'Dismiss Candidate'
        end
        it 'archives the candidate' do
          candidate.reload
          expect(candidate.active).to eq(false)
        end
        it 'redirects to candidates#index' do
          expect(page).to have_content('Candidates')
        end
        it 'flashes a success message' do
          expect(page).to have_content('Candidate dismissed')
        end
      end
      context 'form submission failure' do
        before(:each) do
          click_on 'Dismiss Candidate'
        end
        it 'does not archive the candidate' do
          candidate.reload
          expect(candidate.active).to eq(true)
        end
        it 'renders the dismissal page' do
          expect(page).to have_content('Dismiss Candidate')
        end
        it 'flashes a error message' do
          expect(page).to have_content('Candidate denial reason can not be blank')
        end
      end
    end
  end
end
