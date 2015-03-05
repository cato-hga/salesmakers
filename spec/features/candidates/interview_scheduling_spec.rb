require 'rails_helper'

describe 'Scheduling interviews' do

  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:candidate) { create :candidate }

  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_candidate_interview_schedule_path candidate
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      visit new_candidate_interview_schedule_path candidate
    end

    describe 'date scheduler' do
      it 'contains a form to enter a date' do
        expect(page).to have_content 'Interview Scheduler'
        expect(page).to have_content 'Interview date'
        expect(page).to have_button 'Search for time slots'
      end
      it 'has an option to interview now' do
        expect(page).to have_content 'Interview Now!'
      end

      describe 'when picking' do
        context 'an invalid date' do
          it 'returns a proper error message' do
            fill_in 'interview_date', with: 'totallynotacorrectdateyo'
            click_on 'Search for time slots'
            expect(page).to have_content 'Interview Scheduler'
            expect(page).to have_content 'The date entered could not be used - there may be a typo or invalid date. Please re-enter'
          end
        end
        context 'a valid date' do
          it 'renders the available interview slots for a date' do
            fill_in 'interview_date', with: 'tomorrow'
            click_on 'Search for time slots'
            expect(page).to have_content 'Available Interview Slots for '
            expect(page).to have_content '12:00am EST'
            expect(page).to have_content '9:30am EST'
          end
        end
      end

      describe 'when interviewing now' do
        it 'takes the recruiter to the interview notes section'
      end
    end

    describe 'interview time slots' do
      let!(:interview_schedule) { create :interview_schedule, interview_date: Date.tomorrow, start_time: Time.zone.now.beginning_of_hour }
      before(:each) do
        fill_in 'interview_date', with: 'tomorrow'
        click_on 'Search for time slots'
      end
      it 'displays the time slots available' do
        expect(page).to have_content 'Available Interview Slots for '
        expect(page).to have_content '12:00am EST'
        expect(page).to have_content '9:30am EST'
      end
      it 'does not display taken time slots' do
        save_and_open_page
        expect(page).to have_content friendly_datetime(interview_schedule.start_time)
      end
      describe 'when choosing a slot' do
        it 'schedules the candidate'
        it 'renders the new candidate screen'
      end
    end
  end
end