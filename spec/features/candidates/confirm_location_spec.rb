require 'rails_helper'

describe 'confirming location' do
  let!(:candidate) { create :candidate, location_area: location_area, state: 'FL' }
  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_create, permission_index] }
  let!(:location_area) { create :location_area }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission_create) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_index) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }

  before { CASClient::Frameworks::Rails::Filter.fake(recruiter.email) }

  it 'allows the location to be changed before paperwork is sent' do
    visit new_candidate_interview_answer_path candidate
    fill_in :interview_answer_work_history, with: 'Work History'
    fill_in :interview_answer_why_in_market, with: 'Why in market'
    fill_in :interview_answer_ideal_position, with: 'Ideal position'
    fill_in :interview_answer_what_are_you_good_at, with: 'What are you good at'
    fill_in :interview_answer_what_are_you_not_good_at, with: 'What are you not good at'
    fill_in :interview_answer_compensation_last_job_one, with: 'Comp 1'
    fill_in :interview_answer_compensation_last_job_two, with: 'Comp 2'
    fill_in :interview_answer_compensation_last_job_three, with: 'Comp 3'
    fill_in :interview_answer_compensation_seeking, with: 'Seeking comp'
    fill_in :interview_answer_hours_looking_to_work, with: 'Hours looking to work'
    click_on 'Extend offer'
    expect(page).to have_selector('h1', text: 'Confirm Location')
    expect(page).to have_content(location_area.location.address)
  end

end