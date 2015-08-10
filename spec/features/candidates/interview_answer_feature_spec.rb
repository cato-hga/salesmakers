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
      expect(page).to have_content("Specifically: What was the candidate's last two positions?")
      expect(page).to have_content('Why is candidate in the market')
      expect(page).to have_content("Candidate's ideal position and responsibilities")
      expect(page).to have_content('What is the candidate good at')
      expect(page).to have_content('What is the candidate NOT good at')
      expect(page).to have_content('Candidate willingness description')
      expect(page).to have_content('Candidate personality description')
      expect(page).to have_content('Candidate self motivated description')
      expect(page).to have_content("Candidate's previous compensation (1)")
      expect(page).to have_content("Candidate's previous compensation (2)")
      expect(page).to have_content("Candidate's previous compensation (3)")
      expect(page).to have_content('Pay rate sought')
      expect(page).to have_content('Hours per week looking to work')
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
          expect(page).to have_content "Why in market can't be blank"
          expect(page).to have_content "Ideal position can't be blank"
          expect(page).to have_content "What are you good at can't be blank"
          expect(page).to have_content "What are you not good at can't be blank"
          expect(page).to have_content "Compensation last job one can't be blank"
          expect(page).to have_content "Compensation seeking can't be blank"
          expect(page).to have_content "Hours looking to work can't be blank"
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
          expect(page).to have_content "Work history can't be blank"
          expect(page).to have_content "Why in market can't be blank"
          expect(page).to have_content "Ideal position can't be blank"
          expect(page).to have_content "What are you good at can't be blank"
          expect(page).to have_content "What are you not good at can't be blank"
          expect(page).to have_content "Compensation last job one can't be blank"
          expect(page).to have_content "Compensation seeking can't be blank"
          expect(page).to have_content "Hours looking to work can't be blank"
          expect(page).to have_content "Denial reason must be selected"
        end

        it 'renders new' do
          expect(page).to have_content 'Interview Answers for'
        end
      end

      context 'with valid data' do
        before(:each) do
          fill_in :interview_answer_work_history, with: 'Work History'
          fill_in :interview_answer_why_in_market, with: 'Why in market'
          fill_in :interview_answer_ideal_position, with: 'Ideal position'
          fill_in :interview_answer_what_are_you_good_at, with: 'What are you good at'
          fill_in :interview_answer_what_are_you_not_good_at, with: 'What are you not good at'
          fill_in :interview_answer_willingness_characteristic, with: 'Willing'
          fill_in :interview_answer_personality_characteristic, with: 'What are you not good at'
          fill_in :interview_answer_self_motivated_characteristic, with: 'What are you not good at'
          fill_in :interview_answer_compensation_last_job_one, with: 'Comp 1'
          fill_in :interview_answer_compensation_last_job_two, with: 'Comp 2'
          fill_in :interview_answer_compensation_last_job_three, with: 'Comp 3'
          fill_in :interview_answer_compensation_seeking, with: 'Seeking comp'
          fill_in :interview_answer_hours_looking_to_work, with: 'Hours looking to work'
          fill_in :interview_answer_last_two_positions, with: 'Last two positions'
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
