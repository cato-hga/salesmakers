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
            expect(page).to have_content '12:00am'
            expect(page).to have_content '9:30am'
          end
        end
      end

      describe 'when interviewing now' do
        before(:each) do
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
      let!(:interview_schedule) { create :interview_schedule, interview_date: ('20150305').to_date, start_time: '2015-03-05 09:00:00 -0500' }
      let!(:interview_schedule_two) { create :interview_schedule, interview_date: ('20150305').to_date, start_time: '2015-03-05 23:30:00 -0500' }
      before(:each) do
        fill_in 'interview_date', with: '3/05/2015'
        click_on 'Search for time slots'
      end
      it 'displays the time slots available' do
        expect(page).to have_content 'Available Interview Slots for '
        expect(page).to have_content '12:00am'
        expect(page).to have_content '9:30am'
      end
      it 'does not display taken time slots' do
        expect(page).not_to have_content '9:00am'
        expect(page).not_to have_content '11:30pm'
      end

      describe 'when choosing a slot' do
        before(:each) do
          click_on 'Schedule for 9:30am'
        end
        it 'schedules the candidate' do
          candidate.reload
          expect(InterviewSchedule.count).to eq(3)
          expect(candidate.status).to eq('interview_scheduled')
        end
        it 'renders the new candidate screen' do
          expect(page).to have_content candidate.name
        end
      end
    end
  end
end