require 'rails_helper'

describe 'Candidate dashboard' do
  let!(:recruiter) { create :person, last_name: 'Recruiter', position: position }
  let(:position) { create :position, permissions: [permission] }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission) { Permission.create key: 'candidate_view_all', description: 'Blah blah blah', permission_group: permission_group }

  let!(:entered_candidate) {
    create :candidate,
           mobile_phone: '1111111111',
           status: :entered
  }
  let!(:prescreened_candidate) {
    create :candidate,
           status: :prescreened,
           mobile_phone: '1111111112'
  }
  let!(:location_selected_candidate) {
    create :candidate,
           mobile_phone: '1111111113',
           status: :location_selected
  }
  let!(:interview_scheduled_candidate) {
    create :candidate,
           mobile_phone: '1111111114',
           status: :interview_scheduled
  }
  let!(:accepted_candidate) {
    create :candidate,
           mobile_phone: '1111111116',
           status: :accepted
  }
  let!(:paperwork_sent_candidate) {
    create :candidate,
           mobile_phone: '1111111117',
           status: :paperwork_sent
  }
  let!(:paperwork_completed_by_candidate_candidate) {
    create :candidate,
           mobile_phone: '1111111118',
           status: :paperwork_completed_by_candidate
  }
  let!(:paperwork_completed_by_advocate_candidate) {
    create :candidate,
           mobile_phone: '1111111119',
           status: :paperwork_completed_by_advocate
  }
  let!(:onboarded_candidate) {
    create :candidate,
           mobile_phone: '1111111115',
           status: :onboarded
  }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit dashboard_candidates_path
  end

  it 'shows the number of candidates in entered status' do
    within '#entered' do
      expect(page).to have_selector('.candidate_count', text: '1')
    end
  end
  it 'shows the number of candidates in prescreened status' do
    within '#prescreened' do
      expect(page).to have_selector('.candidate_count', text: '1')
    end
  end
  it 'shows the number of candidates in location_selected status' do
    within '#location_selected' do
      expect(page).to have_selector('.candidate_count', text: '1')
    end
  end
  it 'shows the number of candidates in interview_scheduled status' do
    within '#interview_scheduled' do
      expect(page).to have_selector('.candidate_count', text: '1')
    end
  end
  it 'shows the number of candidates in accepted status' do
    within '#accepted' do
      expect(page).to have_selector('.candidate_count', text: '1')
    end
  end
  it 'shows the number of candidates in paperwork_sent status' do
    within '#paperwork_sent' do
      expect(page).to have_selector('.candidate_count', text: '1')
    end
  end
  it 'shows the number of candidates in paperwork_completed_by_candidate status' do
    within '#paperwork_completed_by_candidate' do
      expect(page).to have_selector('.candidate_count', text: '1')
    end
  end
  it 'shows the number of candidates in paperwork_completed_by_advocate status' do
    within '#paperwork_completed_by_advocate' do
      expect(page).to have_selector('.candidate_count', text: '1')
    end
  end
  it 'shows the number of candidates onboarded' do
    within '#onboarded' do
      expect(page).to have_selector('.candidate_count', text: '1')
    end
  end
end