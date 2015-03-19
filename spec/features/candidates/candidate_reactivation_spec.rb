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
  let!(:reason) { create :candidate_denial_reason }
  let!(:candidate) { create :candidate, active: false, location_area: location_area }
  let(:location_area) { create :location_area, target_head_count: 2, potential_candidate_count: 1 }

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
    end

    it 'should have a link to reactivate a candidate' do
      expect(page).to have_button 'Reactivate Candidate'
    end

    describe 'reactivation success' do
      before(:each) do
        click_button 'Reactivate Candidate'
      end

      it 'confirms, and then reactivates the candidate' do
        candidate.reload
        expect(candidate.active).to eq(true)
      end
      it 'redirects to the candidate#show page' do
        expect(page).to have_content 'Basic Information'
      end
      it 'shows the dismiss candidate button again' do
        expect(page).to have_content 'Dismiss Candidate'
      end
      it 'creates a log entry' do
        visit candidate_path candidate
        expect(page).to have_content 'reactivated'
      end
    end
  end
end
