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
           person: onboarded_person,
           status: :onboarded
  }
  let!(:partially_screened_candidate) {
    create :candidate,
           person: person,
           status: :partially_screened
  }
  let!(:screening) {
    create :screening,
           person: person,
           sex_offender_check: :sex_offender_check_passed,
           public_background_check: :public_background_check_passed,
           private_background_check: :private_background_check_passed
  }
  let!(:fully_screened_candidate) {
    create :candidate,
           person: person,
           status: :fully_screened
  }
  let!(:onboarded_person) {
    create :person
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
      expect(page).to have_selector('.range_count', text: '13')
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
      expect(page).to have_selector('.range_count', text: '3')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
  it 'shows the number of candidates that passed the sex offender check' do
    within '#passed_sex_offender_check' do
      expect(page).to have_selector('.range_count', text: '1')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
  it 'shows the number of candidates that passed the public background check' do
    within '#passed_public_background_check' do
      expect(page).to have_selector('.range_count', text: '1')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
  it 'shows the number of candidates that passed the private background check' do
    within '#passed_private_background_check' do
      expect(page).to have_selector('.range_count', text: '1')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
  it 'shows the number of candidates that passed the drug screening' do
    within '#passed_drug_screening' do
      expect(page).to have_selector('.range_count', text: '0')
      expect(page).to have_selector('.total_count', text: '0')
    end
  end
  it 'shows the number of candidates partially screened' do
    within '#partially_screened' do
      expect(page).to have_selector('.range_count', text: '1')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
  it 'shows the number of candidates fully screened' do
    within '#fully_screened' do
      expect(page).to have_selector('.range_count', text: '1')
      expect(page).to have_selector('.total_count', text: '1')
    end
  end
end