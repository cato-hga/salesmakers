require 'rails_helper'

describe 'Interview answers' do
  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create, candidate_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:candidate_index) { Permission.new key: 'candidate_index',
                                         permission_group: permission_group,
                                         description: 'Test Description' }
  let(:candidate) { create :candidate, location_area: location_area }
  let!(:denial_reason) { create :candidate_denial_reason }
  let(:location_area) { create :location_area }

  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_candidate_interview_answer_path candidate
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      visit new_candidate_interview_answer_path candidate
    end

    it 'contains the form with all relevant fields' do
      expect(page).to have_content(candidate.first_name)
      expect(page).to have_content(candidate.last_name)
      expect(page).to have_content("Candidate's work history")
      expect(page).to have_content("What interests the candidate in the position?")
      expect(page).to have_content('What was the first thing the candidate sold?')
      expect(page).to have_content("What was the first time the candidate had to build a great working relationship?")
      expect(page).to have_content('When was a time that the candidate had to rely on teaching to accomplish a goal?')
      expect(page).to have_content('Candidate willingness description')
      expect(page).to have_content('Candidate personality description')
      expect(page).to have_content('Candidate self motivated description')
      expect(page).to have_content('Pay rate sought')
      expect(page).to have_content('Candidate does have flexible availability and can work 20-30 hours per week?')
      expect(page).to have_content('IF NOT EXTENDING OFFER: Why was candidate denied')
      expect(page).to have_button 'Extend offer'
      expect(page).to have_content 'Do not extend offer'
    end

    describe 'form submission' do
      context 'with invalid data (job offered)' do
        before(:each) do
          click_on 'Extend offer'
        end
        it 'displays relevant error messages' do
          expect(page).to have_content "The candidate's interview answers cannot be saved"
          expect(page).to have_content "Work history can't be blank"
          expect(page).to have_content "What interests you can't be blank"
          expect(page).to have_content "First thing you sold can't be blank"
          expect(page).to have_content "First building of working relationship can't be blank "
          expect(page).to have_content "First rely on teaching can't be blank"
          expect(page).to have_content "Compensation seeking can't be blank"
        end

        it 'renders new' do
          expect(page).to have_content 'Interview Answers for'
        end
      end

      context 'with invalid data (job not offered)' do
        before(:each) do
          find(:xpath, "//input[@id='extend_offer']").set false
          click_on 'Extend offer'
        end

        it 'displays relevant error messages' do
          expect(page).to have_content "The candidate's interview answers cannot be saved"
          expect(page).to have_content "The candidate's interview answers cannot be saved"
          expect(page).to have_content "Work history can't be blank"
          expect(page).to have_content "What interests you can't be blank"
          expect(page).to have_content "First thing you sold can't be blank"
          expect(page).to have_content "First building of working relationship can't be blank "
          expect(page).to have_content "First rely on teaching can't be blank"
          expect(page).to have_content "Compensation seeking can't be blank"
          expect(page).to have_content "Denial reason must be selected"
        end

        it 'renders new' do
          expect(page).to have_content 'Interview Answers for'
        end
      end

      context 'with valid data' do
        before(:each) do
          fill_in :interview_answer_work_history, with: 'Work History'
          fill_in :interview_answer_what_interests_you, with: 'What interests you'
          fill_in :interview_answer_first_thing_you_sold, with: 'first_thing_you_sold'
          fill_in :interview_answer_first_building_of_working_relationship, with: 'first_building_of_working_relationship'
          fill_in :interview_answer_first_rely_on_teaching, with: 'first_rely_on_teaching'
          fill_in :interview_answer_willingness_characteristic, with: 'Willing'
          fill_in :interview_answer_personality_characteristic, with: 'What are you not good at'
          fill_in :interview_answer_self_motivated_characteristic, with: 'What are you not good at'
          fill_in :interview_answer_compensation_seeking, with: 'Seeking comp'
          select 'Yes', from: :interview_answer_availability_confirm
        end
        context 'and job extended, location recruitable' do
          before(:each) do
            click_on 'Extend offer'
          end
          it 'displays a confirmation' do
            expect(page).to have_content 'Confirm Details'
          end
          it 'redirects to the location confirmation page' do
            expect(page).to have_content location_area.location.address
          end
          it 'does not assign a denial reason' do
            candidate.reload
            expect(candidate.candidate_denial_reason).to be_nil
          end
        end

        context 'and job extended, location no longer recruitable' do
          before(:each) do
            allow_any_instance_of(LocationArea).to receive(:head_count_full?).and_return(true)
            click_on 'Extend offer'
          end
          it 'does not assign a denial reason' do
            candidate.reload
            expect(candidate.candidate_denial_reason).to be_nil
          end
          it 'removes the candidates selected location' do
            candidate.reload
            expect(candidate.location_area).to eq(nil)
          end
          it 'redirects to the candidates profile page' do
            expect(current_path).to eq(candidate_path(candidate))
          end
          it 'shows the full error on the candidate location page' do
            expect(page).to have_content 'The location selected for the candidate was recently filled or is not recruitable. Please select a new, recruitable, location'
          end
        end

        context 'and job not extended' do
          before(:each) do
            find(:xpath, "//input[@id='extend_offer']").set false
            select denial_reason.name, from: :interview_answer_candidate_candidate_denial_reason_id
            click_on 'Extend offer'
          end
          it 'display a confirmation' do
            expect(page).to have_content 'Interview answers saved and candidate deactivated'
          end
          it 'redirects to new candidate screen' do
            expect(page).to have_content 'New Candidate'
          end
          it 'deactivates the candidate' do
            candidate.reload
            expect(candidate.active).to eq(false)
          end
          it 'assigns a denial reason' do
            candidate.reload
            expect(candidate.candidate_denial_reason).not_to be_nil
            expect(candidate.candidate_denial_reason).to eq(denial_reason)
          end
        end
      end
    end
  end
end
