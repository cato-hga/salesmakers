require 'rails_helper'

describe 'Scheduling interviews' do

  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'candidate_index',
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
      Time.zone = ActiveSupport::TimeZone["Eastern Time (US & Canada)"]
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      visit new_candidate_interview_schedule_path candidate
    end

    describe 'date scheduler' do
      it 'contains a form to enter a date' do
        expect(page).to have_content 'Interview Scheduler'
        expect(page).to have_content 'Interview date'
        expect(page).to have_button 'Search for time slots'
      end

      describe 'when picking' do
        context 'an invalid date' do
          it 'returns a proper error message' do
            fill_in 'interview_date', with: 'totallynotacorrectdateyo'
            fill_in 'cloud_room', with: '33333'
            click_on 'Search for time slots'
            expect(page).to have_content 'Interview Scheduler'
            expect(page).to have_content 'The date entered could not be used - there may be a typo or invalid date. Please re-enter'
          end
        end
        context 'a date in the past' do
          it 'returns a proper error message' do
            fill_in 'interview_date', with: 'yesterday'
            fill_in 'cloud_room', with: '33333'
            click_on 'Search for time slots'
            expect(page).to have_content 'Interview Scheduler'
            expect(page).to have_content 'The date entered could not be used - there may be a typo or invalid date. Please re-enter'
          end
        end
        context 'no cloud room selected' do
          it 'returns an error message' do
            fill_in 'interview_date', with: 'tomorrow'
            click_on 'Search for time slots'
            expect(page).to have_content 'Interview Scheduler'
            expect(page).to have_content 'Cloud room is required'
          end
        end
        context 'a valid date' do
          it 'renders the available interview slots for a date' do
            fill_in 'interview_date', with: 'tomorrow'
            fill_in 'cloud_room', with: '33333'
            click_on 'Search for time slots'
            expect(page).to have_content 'Available Interview Slots for '
            expect(page).to have_content '3:00pm'
            expect(page).to have_content '9:30am'
          end
        end
      end

      describe 'when interviewing now' do
        before(:each) do
          fill_in 'interview_date', with: 'today'
          fill_in 'cloud_room', with: '33333'
          click_on 'Search for time slots'
          click_on 'Interview Now!'
        end

        it 'takes the recruiter to the interview notes section' do
          expect(page).to have_content ('Interview Answers')
        end
        it 'the candidates status is changed to scheduled' do
          candidate.reload
          expect(candidate.status).to eq('interview_scheduled')
        end
      end
    end

    describe 'interview time slots' do
      let(:other_candidate) { create :candidate }
      let(:interview_date) { Date.current }
      let(:interview_time_one) { Time.zone.local(interview_date.year, interview_date.month, interview_date.day, 9, 0, 0) }
      let(:interview_time_two) { Time.zone.local(interview_date.year, interview_date.month, interview_date.day, 18, 30, 0) }
      let!(:interview_schedule) { create :interview_schedule,
                                         candidate: other_candidate,
                                         interview_date: interview_date,
                                         start_time: interview_time_one,
                                         person: recruiter
      }
      let!(:interview_schedule_two) { create :interview_schedule,
                                             candidate: other_candidate,
                                             interview_date: interview_date,
                                             start_time: interview_time_two,
                                             person: other_recruiter
      }
      let(:other_recruiter) { create :person, position: position }
      let(:position) { create :position, name: 'Advocate', permissions: [permission_create, permission_index] }

      before(:each) do
        fill_in 'interview_date', with: 'today'
        fill_in 'What is your LifeSize cloud room?', with: '33333'
        click_on 'Search for time slots'
      end

      it 'has an option to interview now' do
        expect(page).to have_content 'Interview Now!'
      end

      it 'displays the time slots available' do
        expect(page).to have_content 'Available Interview Slots for '
        expect(page).to have_content '3:00pm'
        expect(page).to have_content '9:30am'
      end
      it 'does not display taken time slots for the recruiter' do
        expect(page).not_to have_content '9:00am'
      end
      it 'does not display time slots outside of 9am to 8:30 pm' do
        expect(page).not_to have_content '8:30am'
        expect(page).not_to have_content '9:00pm'
      end
      it 'does not remove time slots used by another recruiter' do
        expect(page).to have_content '6:30pm'
      end
      describe 'when choosing a slot' do
        before(:each) do
          within('.inner') do
            first('.button').click
          end
        end

        it 'schedules the candidate' do
          candidate.reload
          expect(InterviewSchedule.count).to eq(3)
          expect(candidate.status).to eq('interview_scheduled')
        end
        it 'renders the new candidate screen' do
          expect(page).to have_content candidate.name
        end
        it 'schedules the correct time (Screw you time zones!)' do
          candidate.reload
          time = candidate.interview_schedules.first.start_time.in_time_zone('Eastern Time (US & Canada)')
          expect(time.strftime('%H%M%S')).to eq('093000')
        end
        it 'assigns the person to the schedule' do
          schedule = InterviewSchedule.find_by candidate: candidate
          expect(schedule.person).to eq(recruiter)
        end
      end
    end

    describe 'rescheduling from the candidate#show page' do
      let(:scheduled_interview) { create :interview_schedule }
      let!(:scheduled_candidate) { create :candidate, interview_schedules: [scheduled_interview], status: 'interview_scheduled' }

      before(:each) do
        visit candidate_path scheduled_candidate
      end

      it 'has a button for rescheduling' do
        expect(page).to have_content 'Reschedule Interview'
      end

      #Not testing anything else, handling everything else in the controller
    end
  end

end
