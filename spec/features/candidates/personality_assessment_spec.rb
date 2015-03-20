require 'rails_helper'

describe 'personality assessment functionality' do
  let!(:candidate) { create :candidate, state: 'FL', status: :accepted }
  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission_create) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_index) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  let!(:job_offer_detail) { create :job_offer_detail, candidate: candidate }

  before { CASClient::Frameworks::Rails::Filter.fake(recruiter.email) }

  context 'when the assessment is not required' do
    let(:location_area) { create :location_area }

    before do
      candidate.update location_area: location_area
    end

    it 'does not show the link to the assessment completion' do
      visit candidate_path(candidate)
      expect(page).not_to have_selector('input[value="Mark Personality Assessment Passed"]')
      expect(page).not_to have_selector('input[value="Mark Personality Assessment Failed"]')
    end
  end

  context 'when the assessment is required' do
    let(:area) { create :area, personality_assessment_url: 'https://google.com' }
    let(:location_area) { create :location_area, area: area }

    before do
      candidate.update location_area: location_area
    end

    describe 'when the assessment is not completed' do
      it 'shows the link to assessment completion' do
        visit candidate_path(candidate)
        expect(page).to have_selector('input[value="Mark Personality Assessment Passed"]')
        expect(page).to have_selector('input[value="Mark Personality Assessment Failed"]')
      end
    end

    describe 'when the assessment is completed' do
      before { candidate.update personality_assessment_completed: true }

      it 'does not show the link to the assessment completion' do
        visit candidate_path(candidate)
        expect(page).not_to have_selector('input[value="Mark Personality Assessment Passed"]')
        expect(page).not_to have_selector('input[value="Mark Personality Assessment Failed"]')
      end

      context 'but the location is not confirmed' do
        let(:candidate_no_offer) { create :candidate, status: :accepted }
        it 'shows a button for confirming location' do
          visit candidate_path(candidate_no_offer)
          expect(page).to have_content 'Confirm Location and Send Paperwork'
        end
      end
    end
  end
end