require 'rails_helper'

describe 'viewing Candidate interview schedules' do
  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_index) { Permission.new key: 'candidate_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let!(:permission_view_all) { Permission.new key: 'candidate_view_all',
                                              permission_group: permission_group,
                                              description: 'Test Description' }
  let(:candidate) { create :candidate }
  let!(:interview_schedule) {
    create :interview_schedule,
           candidate: candidate,
           person: recruiter,
           interview_date: Date.today,
           start_time: Time.now.beginning_of_hour
  }

  before { CASClient::Frameworks::Rails::Filter.fake(recruiter.email) }

  context 'for those without candidate_view_all permission' do
    before { visit interview_schedules_path(Date.today.to_s) }

    it 'has the correct page title' do
      expect(page).to have_selector('h1', text: 'Interview Schedules')
      expect(page).to have_selector('h3', Date.today.strftime('%A, %B %-d, %Y'))
    end

    it 'shows each time slot' do
      expect(page).to have_content((Time.zone.now + 2.hours).beginning_of_hour.strftime('%-l:%M'))
    end

    it 'shows the candidate link' do
      expect(page).to have_selector('a', text: candidate.name)
    end

    it 'goes to the previous date' do
      click_on 'previous_schedule_date'
      expect(page).to have_selector('h3', (Time.zone.now.beginning_of_day - 1.day).strftime('%A, %B %-d, %Y'))
    end

    it 'goes to the next date' do
      click_on 'next_schedule_date'
      expect(page).to have_selector('h3', (Time.zone.now.beginning_of_day + 1.day).strftime('%A, %B %-d, %Y'))
    end

    it 'allows removing a candidate from the schedule' do
      expect(page).to have_button 'Cancel Interview'
      click_on 'Cancel Interview'
      expect(page).not_to have_button 'Cancel Interview'
    end
  end

  context 'for those with candidate_view_all permission' do
    let(:permission_view_all) { create :permission, key: 'candidate_view_all' }

    before { recruiter.position.permissions << permission_view_all }

    specify 'can view all candidate schedules for all recruiters'
  end
end