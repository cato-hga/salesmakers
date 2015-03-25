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
  let!(:yesterday_entered_candidate) {
    create :candidate,
           mobile_phone: '1111111120',
           status: :entered,
           created_at: Date.yesterday
  }
  let!(:prescreened_candidate) {
    create :candidate,
           status: :prescreened,
           mobile_phone: '1111111112'
  }
  let!(:prescreen_answer) {
    create :prescreen_answer,
           candidate: prescreened_candidate
  }
  let!(:yesterday_prescreen_answer) {
    create :prescreen_answer,
           created_at: Date.yesterday
  }
  let!(:interview_scheduled_candidate) {
    create :candidate,
           mobile_phone: '1111111114',
           status: :interview_scheduled
  }
  let!(:interview_schedule) {
    create :interview_schedule,
           candidate: interview_scheduled_candidate
  }
  let!(:yesterday_interview_schedule) {
    create :interview_schedule,
           created_at: Date.yesterday
  }
  let!(:accepted_candidate) {
    create :candidate,
           mobile_phone: '1111111116',
           status: :accepted
  }
  let!(:interview_answer) {
    create :interview_answer,
           candidate: accepted_candidate
  }
  let!(:paperwork_sent_candidate) {
    create :candidate,
           mobile_phone: '1111111117',
           status: :paperwork_sent
  }
  let!(:job_offer_detail) {
    create :job_offer_detail,
           candidate: paperwork_sent_candidate,
           sent: Time.now
  }
  let!(:paperwork_completed_by_candidate_candidate) {
    create :candidate,
           mobile_phone: '1111111118',
           status: :paperwork_completed_by_candidate
  }
  let!(:candidate_job_offer_detail) {
    create :job_offer_detail,
           candidate: paperwork_completed_by_candidate_candidate,
           completed_by_candidate: DateTime.now
  }
  let!(:paperwork_completed_by_advocate_candidate) {
    create :candidate,
           mobile_phone: '1111111119',
           status: :paperwork_completed_by_advocate
  }
  let!(:advocate_job_offer_detail) {
    create :job_offer_detail,
           candidate: paperwork_completed_by_advocate_candidate,
           completed_by_advocate: DateTime.now
  }
  let!(:paperwork_completed_by_hr_candidate) {
    create :candidate,
           mobile_phone: '1111111122',
           status: :paperwork_completed_by_hr
  }
  let!(:hr_job_offer_detail) {
    create :job_offer_detail,
           candidate: paperwork_completed_by_hr_candidate,
           completed: DateTime.now
  }
  let!(:onboarded_candidate) {
    create :candidate,
           mobile_phone: '1111111115',
           person: person,
           status: :onboarded
  }
  let!(:person) {
    create :person
  }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit dashboard_candidates_path
  end

  it 'shows the number of candidates in entered status' do
    within '#entered' do
      expect(page).to have_selector('.range_count', text: '11')
      expect(page).to have_selector('.total_count', text: '4')
    end
  end
  it 'shows the number of candidates in prescreened status' do
    within '#prescreened' do
      expect(page).to have_selector('.range_count', text: '1')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
  it 'shows the number of candidates in interview_scheduled status' do
    within '#interview_scheduled' do
      expect(page).to have_selector('.range_count', text: '1')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
  it 'shows the number of candidates in accepted status' do
    within '#accepted' do
      expect(page).to have_selector('.range_count', text: '1')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
  it 'shows the number of candidates in paperwork_sent status' do
    within '#paperwork_sent' do
      expect(page).to have_selector('.range_count', text: '4')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
  it 'shows the number of candidates in paperwork_completed_by_candidate status' do
    within '#paperwork_completed_by_candidate' do
      expect(page).to have_selector('.range_count', text: '1')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
  it 'shows the number of candidates in paperwork_completed_by_advocate status' do
    within '#paperwork_completed_by_advocate' do
      expect(page).to have_selector('.range_count', text: '1')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
  it 'shows the number of candidates in paperwork_completed_by_hr status' do
    within '#paperwork_completed_by_hr' do
      expect(page).to have_selector('.range_count', text: '1')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
  it 'shows the number of candidates onboarded' do
    within '#onboarded' do
      expect(page).to have_selector('.range_count', text: '1')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
end