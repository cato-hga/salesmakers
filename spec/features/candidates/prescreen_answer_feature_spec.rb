require 'rails_helper'
describe 'Prescreen answers' do
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
      visit new_candidate_prescreen_answer_path candidate
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      visit new_candidate_prescreen_answer_path candidate
    end

    it 'has the new candidate form with all fields' do
      expect(page).to have_content('Candidate has not worked for SalesMakers')
      expect(page).to have_content('Candidate is over 18')
      expect(page).to have_content('Candidate has an eligible smart phone')
      expect(page).to have_content('Candidate can work weekends')
      expect(page).to have_content('Candidate has access to reliable transportation')
      expect(page).to have_content('Candidate has access to a computer or tablet')
      expect(page).to have_content('Candidate is looking for part time employment')
      expect(page).to have_content('Candidate gave permission for background check and drug screen')
      expect(page).to have_content('Is this call inbound or outbound?')
      expect(page).to have_button 'Save Answers'
    end

    describe 'form submission' do
      context 'with any checkboxes missed' do #Person cannot work for us, exits process
        before(:each) do
          select 'Outbound', from: 'Is this call inbound or outbound?'
          click_on 'Save Answers'
        end
        it 'redirects to candidate#new' do
          expect(page).to have_content 'New Candidate'
        end
        it 'flashes an error message' do
          expect(page).to have_content 'Candidate did not pass prescreening'
        end
      end

      context 'with all fields selected' do
        before(:each) do
          check :prescreen_answer_worked_for_salesmakers
          check :prescreen_answer_of_age_to_work
          check :prescreen_answer_eligible_smart_phone
          check :prescreen_answer_can_work_weekends
          check :prescreen_answer_reliable_transportation
          check :prescreen_answer_access_to_computer
          check :prescreen_answer_part_time_employment
          check :prescreen_answer_ok_to_screen
          select 'Inbound', from: 'Is this call inbound or outbound?'
          click_on 'Save Answers'
        end

        it 'displays a flash message' do
          expect(page).to have_content 'Answers saved'
        end
        it 'redirects to the prescreen questions page', pending: 'Not available yet' do
          expect(page).to have_content 'Location Selection'
        end
        it 'sets the direction of the call' do
          expect(CandidateContact.first.inbound?).to be_truthy
        end
      end
    end
  end
end