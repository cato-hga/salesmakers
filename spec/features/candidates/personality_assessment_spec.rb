require 'rails_helper'

describe 'personality assessment functionality' do
  let!(:candidate) { create :candidate, state: 'FL', status: :accepted, personality_assessment_status: :incomplete }
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
      expect(page).not_to have_selector('input[value="Record Assessment Score"]')
    end
  end

  context 'when the assessment is required' do
    let(:area) { create :area,
                        personality_assessment_url: 'https://google.com'
    }
    let(:location_area) { create :location_area, area: area }

    before do
      candidate.update location_area: location_area
    end

    describe 'when the assessment is not completed' do
      it 'shows the form for assessment score' do
        visit candidate_path(candidate)
        expect(page).to have_selector('input[value="Record Assessment Score"]')
      end

      it 'records the assessment score' do
        visit candidate_path(candidate)
        fill_in 'assessment_score', with: '29'
        click_on 'Record Assessment Score'
        expect(page).to have_content('disqualified')
      end

      it 'displays an error when the score is not a number' do
        visit candidate_path(candidate)
        fill_in 'assessment_score', with: 'aa'
        click_on 'Record Assessment Score'
        expect(page).to have_content('must be a number')
      end
    end

    describe 'when the assessment is completed' do
      before { candidate.update personality_assessment_completed: true }

      it 'does not show the form for assessment score' do
        visit candidate_path(candidate)
        expect(page).not_to have_selector('input[value="Record Assessment Score"]')
      end
    end
  end
end