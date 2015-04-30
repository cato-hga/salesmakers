require 'rails_helper'
describe 'Prescreen answers' do
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
  let(:location_area) { create :location_area }

  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_candidate_prescreen_answer_path candidate
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do

    before(:each) do
      candidate.update location_area: location_area
      candidate.reload
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      visit new_candidate_prescreen_answer_path candidate
    end

    it 'has the prescreen candidate form with all fields' do
      expect(page).to have_content('Has the candidate worked for RadioShack')
      expect(page).to have_content('Candidate has not worked for SalesMakers')
      expect(page).to have_content('Candidate has not worked for Sprint, or is eligible for rehire')
      expect(page).to have_content('Candidate is over 18')
      expect(page).to have_content('Candidate has achieved a high school diploma or equivalant')
      expect(page).to have_content('Candidate has an eligible smart phone and/or computer')
      expect(page).to have_content('Candidate can work weekends and is OK with 20-24 hours')
      expect(page).to have_content('Candidate has access to reliable transportation')
      expect(page).to have_content('Candidate gave permission for background check and drug screen')
      expect(page).to have_content('Candidate does not have any visible tattoos')
      expect(page).to have_content('Is this call inbound or outbound?')
      expect(page).to have_button 'Save Answers'
      within('.availability') do
        expect(page).to have_content 'Candidate Availability'
        expect(page).to have_content('10-2', count: 7)
        expect(page).to have_content('2-6', count: 7)
        expect(page).to have_content('5-9', count: 7)
      end
    end

    describe 'prescreen form submission' do

      # describe 'handling RadioShack Employment' do
      #   context 'when the candidate has worked for radioshack', js: true do
      #     it 'requires an answer to employment dates and store number/city/state' do
      #       select 'Yes', from: :prescreen_answer_worked_for_radioshack
      #       click_on 'Save Answers'
      #       expect(page).to have_content 'Start of radioshack employment must be entered'
      #       expect(page).to have_content 'End of radioshack employment must be entered'
      #       expect(page).to have_content 'Store number, city, and state of previous radioshack location must be selected'
      #     end
      #     it 'a saving success redirects to candidate#show and flashes a message about vetting' do
      #       select 'Yes', from: :prescreen_answer_worked_for_radioshack
      #       fill_in :prescreen_answer_former_employment_date_start, with: '05/25/2007'
      #       fill_in :prescreen_answer_former_employment_date_end, with: '05/25/2008'
      #       fill_in :prescreen_answer_store_number_city_state, with: '3333, St Pete, FL'
      #       check :prescreen_answer_worked_for_sprint
      #       check :prescreen_answer_of_age_to_work
      #       check :prescreen_answer_high_school_diploma
      #       check :prescreen_answer_eligible_smart_phone
      #       check :prescreen_answer_can_work_weekends
      #       check :prescreen_answer_reliable_transportation
      #       check :prescreen_answer_ok_to_screen
      #       check :prescreen_answer_visible_tattoos
      #       check :candidate_availability_monday_first
      #       select 'Inbound', from: 'Is this call inbound or outbound?'
      #       click_on 'Save Answers'
      #       expect(page).to have_content 'Prescreen Answers saved!'
      #       expect(page).to have_content 'The candidate must be vetted by Sprint before proceeding.'
      #       expect(page).to have_content candidate.name
      #     end
      #     it 'sends an email to Sprint'
      #   end
      # end
      context 'with any prescreen checkboxes missed, and availability selected' do #Person cannot work for us, exits process
        before(:each) do
          check :candidate_availability_monday_first
          select 'Outbound', from: 'Is this call inbound or outbound?'
          click_on 'Save Answers'
        end
        it 'redirects to candidate#new' do
          expect(page).to have_content 'New Candidate'
        end
        it 'flashes an error message' do
          expect(page).to have_content 'Candidate did not pass prescreening'
        end
        it 'saves the candidates availability' do
          candidate.reload
          expect(candidate.candidate_availability).not_to be_nil
        end
      end

      context 'with all fields selected, and availability selected' do
        before(:each) do
          check :prescreen_answer_worked_for_sprint
          check :prescreen_answer_of_age_to_work
          check :prescreen_answer_high_school_diploma
          check :prescreen_answer_eligible_smart_phone
          check :prescreen_answer_can_work_weekends
          check :prescreen_answer_reliable_transportation
          check :prescreen_answer_ok_to_screen
          check :prescreen_answer_visible_tattoos
          check :candidate_availability_monday_first
          select 'Inbound', from: 'Is this call inbound or outbound?'
          click_on 'Save Answers'
        end

        it 'displays a flash message' do
          expect(page).to have_content 'Answers and Availability saved'
        end
        it 'redirects to the select location page' do
          within('header h1') do
            expect(page).to have_content 'Interview Scheduler'
          end
        end
        it 'sets the direction of the call' do
          expect(CandidateContact.first.inbound?).to be_truthy
        end
        it 'sets the correct contact info' do
          expect(CandidateContact.first.notes).to eq('Candidate prescreened successfully.')
        end
        it 'saves the candidates availability' do
          candidate.reload
          expect(candidate.candidate_availability).not_to be_nil
        end

        it 'updates the candidates status' do
          candidate.reload
          expect(candidate.status).to eq('prescreened')
        end
      end

      context 'with all fields selected, and availability NOT selected' do
        before(:each) do
          check :prescreen_answer_worked_for_sprint
          check :prescreen_answer_of_age_to_work
          check :prescreen_answer_high_school_diploma
          check :prescreen_answer_eligible_smart_phone
          check :prescreen_answer_can_work_weekends
          check :prescreen_answer_reliable_transportation
          check :prescreen_answer_ok_to_screen
          select 'Inbound', from: 'Is this call inbound or outbound?'
          click_on 'Save Answers'
        end

        it 'displays a flash message' do
          expect(page).to have_content "At least one availability checkbox must be selected"
        end
        it 'redirects to the prescreen questions page' do
          expect(page).to have_content 'Prescreen Answers'
        end
        it 'does not set the direction of the call or create a candidate Contact' do
          expect(CandidateContact.count).to be(0)
        end
        it ' does not save the candidates availability' do
          candidate.reload
          expect(candidate.candidate_availability).to be_nil
        end
        it 'does not save the prescreen answers' do
          candidate.reload
          expect(candidate.prescreen_answers.count).to be(0)
        end
      end
    end

    describe 'from the candidate#show page, without a location area' do
      let(:location_less_candidate) { create :candidate }
      it 'redirects back to the candidate show' do
        CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
        visit candidate_path(location_less_candidate)
        within('.prescreen') do
          click_on 'INCOMPLETE'
        end
        expect(current_path).to eq(new_candidate_prescreen_answer_path(location_less_candidate))
        check :prescreen_answer_worked_for_sprint
        check :prescreen_answer_of_age_to_work
        check :prescreen_answer_high_school_diploma
        check :prescreen_answer_eligible_smart_phone
        check :prescreen_answer_can_work_weekends
        check :prescreen_answer_reliable_transportation
        check :prescreen_answer_ok_to_screen
        check :prescreen_answer_visible_tattoos
        check :candidate_availability_monday_first
        select 'Inbound', from: 'Is this call inbound or outbound?'
        click_on 'Save Answers'
        expect(current_path).to eq(candidate_path(location_less_candidate))
      end
    end
  end
end