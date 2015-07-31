require 'rails_helper'
describe 'Candidate reactivation' do
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
  let(:person) { create :person }

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

    it 'does not contain the reactivate button if there is a deactivated person attached to the candidate' do
      candidate.update person: person
      candidate.reload
      visit candidate_path candidate
      expect(page).to have_button "Reactivate Candidate"
      person.update active: false
      person.reload
      candidate.reload
      visit candidate_path candidate
      expect(page).not_to have_button 'Reactivate Candidate'
    end

    describe 'reactivation success' do
      let(:offer) { create :job_offer_detail }
      let(:interview) { create :interview_answer }
      let(:schedule) { create :interview_schedule }
      let(:answers) { create :prescreen_answer }
      it 'confirms, and then reactivates the candidate' do
        expect(candidate.active).to eq(false)
        click_button 'Reactivate Candidate'
        candidate.reload
        expect(candidate.active).to eq(true)
      end
      it 'redirects to the candidate#show' do
        click_button 'Reactivate Candidate'
        expect(page).to have_content 'Basic Information'
        expect(page).to have_content 'Please select a location for candidate'
      end
      it 'shows the dismiss candidate button again' do
        click_button 'Reactivate Candidate'
        visit candidate_path candidate
        expect(page).to have_content 'Dismiss Candidate'
      end
      it 'creates a log entry' do
        click_button 'Reactivate Candidate'
        visit candidate_path candidate
        expect(page).to have_content 'Reactivated'
      end

      it 'resets the candidate to a paperwork sent status if applicable' do
        candidate.job_offer_details << offer
        click_button 'Reactivate Candidate'
        candidate.reload
        expect(candidate.location_area).to eq(nil)
        expect(candidate.status).to eq('paperwork_sent')
      end

      it 'resets the candidate to an interviewed status if applicable' do
        candidate.interview_answers << interview
        click_button 'Reactivate Candidate'
        candidate.reload
        expect(candidate.location_area).to eq(nil)
        expect(candidate.status).to eq('interviewed')
      end
      it 'resets the candidate to a scheduled status if applicable' do
        candidate.interview_schedules << schedule
        click_button 'Reactivate Candidate'
        candidate.reload
        expect(candidate.location_area).to eq(nil)
        expect(candidate.status).to eq('interview_scheduled')
      end
      it 'clears location selected and sets the correct status' do
        #Candidate factory in this test has location_area
        click_button 'Reactivate Candidate'
        candidate.reload
        expect(candidate.location_area).to eq(nil)
        expect(candidate.status).to eq('entered')
      end
      it 'resets the candidate to a prescreened status if applicable' do
        #Candidate factory in this test has location_area
        candidate.location_area = nil
        candidate.prescreen_answers << answers
        candidate.save
        click_button 'Reactivate Candidate'
        candidate.reload
        expect(candidate.location_area).to eq(nil)
        expect(candidate.status).to eq('prescreened')
      end
      it 'resets the candidate to a entered status if applicable' do
        #Candidate factory in this test has location_area
        candidate.location_area = nil
        candidate.save
        click_button 'Reactivate Candidate'
        candidate.reload
        expect(candidate.status).to eq('entered')
      end
    end
  end
end
