require 'rails_helper'

describe 'personality assessment functionality' do
  let!(:candidate) { create :candidate, state: 'FL', status: :accepted, personality_assessment_status: :incomplete }
  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_create, permission_index, permission_record_assessment] }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission_create) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_index) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_record_assessment) { Permission.create key: 'candidate_record_assessment', description: 'Blah blah blah', permission_group: permission_group }
  let!(:job_offer_detail) { create :job_offer_detail, candidate: candidate }

  before { CASClient::Frameworks::Rails::Filter.fake(recruiter.email) }

  context 'when the assessment is required' do
    let(:project) { create :project, name: 'STAR' }
    let(:area) { create :area,
                        personality_assessment_url: 'https://google.com',
                        project: project
    }
    let(:location_area) { create :location_area, area: area, priority: 1 }

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

      it 'dismisses a candidate when the score is too low' do
        visit candidate_path(candidate)
        fill_in 'assessment_score', with: '29'
        click_on 'Record Assessment Score'
        candidate.reload
        expect(candidate.status).to eq('rejected')
        expect(candidate.active).to eq(false)
        expect(candidate.personality_assessment_status).to eq('disqualified')
      end

      it 'displays an error when the score is not a number' do
        visit candidate_path(candidate)
        fill_in 'assessment_score', with: 'aa'
        click_on 'Record Assessment Score'
        expect(page).to have_content('must be a number')
      end

      it 'records the assessment score for outsourced locations' do
        area.update personality_assessment_url: nil
        location_area.update outsourced: true
        visit candidate_path(candidate)
        fill_in 'assessment_score', with: '99'
        expect {
          click_on 'Record Assessment Score'
          candidate.reload
        }.to change(candidate, :personality_assessment_score).from(nil).to(99.0)
      end
    end

    describe 'when the assessment is completed' do
      before { candidate.update personality_assessment_completed: true, personality_assessment_score: 29 }

      it 'does not show the form for assessment score' do
        visit candidate_path(candidate)
        expect(page).not_to have_selector('input[value="Record Assessment Score"]')
      end
    end

    describe 'when the assessment is failed' do
      before { candidate.update personality_assessment_completed: true, personality_assessment_score: 11, personality_assessment_status: :disqualified }

      it 'does not show the form for assessment score' do
        visit candidate_path(candidate)
        expect(page).not_to have_selector('input[value="Record Assessment Score"]')
      end
    end

    describe 'for confirmed candidates' do
      it 'sends paperwork' do
        candidate.update status: :confirmed
        candidate.reload
        visit candidate_path(candidate)
        fill_in 'assessment_score', with: '99'
        click_on 'Record Assessment Score'
        expect(page).to have_content 'Paperwork sent successfully.'
      end
    end
  end

  context 'when a personality assessment completion score has not been recorded, but the candidate was marked as completed' do
    let(:other_candidate) { create :candidate,
                                   personality_assessment_completed: true,
                                   personality_assessment_status: 0,
                                   personality_assessment_score: nil,
                                   location_area: location_area
    }
    let(:project) { create :project, name: 'STAR' }
    let(:area) { create :area,
                        personality_assessment_url: 'https://google.com',
                        project: project
    }
    let(:location_area) { create :location_area, area: area }

    before(:each) do
      visit candidate_path other_candidate
    end
    it 'shows the form for assessment score' do
      expect(page).to have_selector('input[value="Record Assessment Score"]')
    end

    it 'records the assessment score' do
      fill_in 'assessment_score', with: '29'
      click_on 'Record Assessment Score'
      expect(page).to have_content('disqualified')
      other_candidate.reload
      expect(other_candidate.personality_assessment_status).to eq('disqualified')
      expect(other_candidate.personality_assessment_score).to eq(29)
      expect(other_candidate.personality_assessment_completed).to eq(true)
    end

    it 'dismisses a candidate when the score is too low' do
      fill_in 'assessment_score', with: '29'
      click_on 'Record Assessment Score'
      other_candidate.reload
      expect(other_candidate.status).to eq('rejected')
      expect(other_candidate.active).to eq(false)
      expect(other_candidate.personality_assessment_status).to eq('disqualified')
    end

    it 'records a passing score correctly' do
      fill_in 'assessment_score', with: '51'
      click_on 'Record Assessment Score'
      other_candidate.reload
      expect(other_candidate.status).to eq('entered') #since this fake candidate hasn't had anything done.
      expect(other_candidate.active).to eq(true)
      expect(other_candidate.personality_assessment_status).to eq('qualified')
    end

    it 'does not show the form afterwards' do
      fill_in 'assessment_score', with: '51'
      click_on 'Record Assessment Score'
      expect(page).not_to have_selector('input[value="Record Assessment Score"]')
    end


  end
end