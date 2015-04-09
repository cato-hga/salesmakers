require 'rails_helper'

describe 'Scheduling a candidate for a drug test' do
  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create, permission_index, permission_view_all] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'candidate_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let(:permission_view_all) { Permission.create key: 'candidate_view_all',
                                                description: 'Blah blah blah',
                                                permission_group: permission_group }
  let(:candidate) { create :candidate }

  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit candidate_path candidate
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      visit candidate_path candidate
    end

    it 'contains the button for drug test scheduling' do
      within('header h1') do
        expect(page).to have_content 'Drug Test Scheduling'
      end
    end

    context 'updating a candidate who has not scheduled their drug test' do
      before(:each) do
        click_on 'Drug Test Scheduling'
        select 'No', from: :candidate_drug_test_scheduled
        click_on 'Save'
      end
      it 'creates a CanidateDrugTest' do
        expect(CandidateDrugTest.count).to eq(1)
      end

      it 'creates a log entry' do
        visit candidate_path candidate
        expect(page).to have_content 'has not scheduled their drug test'
      end
      it 'redirects to candidate index' do
        expect(current_path).to eq(candidates_path)
      end
      it 'flashes a success message' do
        expect(page).to have_content 'Drug Test information successfully updated'
      end
    end

    context 'updating a candidate who has scheduld their drug test' do
      before(:each) do
        click_on 'Drug Test Scheduling'
        select 'Yes', from: :scheduled
        fill_in :candidate_drug_test_test_date, with: 'monday 12:10pm'
        click_on 'Save'
      end

      it 'creates a log entry' do
        visit candidate_path candidate
        expect(page).to have_content 'has scheduled their drug test'
      end
      it 'creates a drug test' do
        expect(CandidateDrugTest.count).to eq(1)
      end
    end

    context 'submission failure (invalid date)' do
      it 'shows all error messages' do
        click_on 'Drug Test Scheduling'
        select 'Yes', from: :scheduled
        fill_in :candidate_drug_test_test_date, with: 'totallynotrightdate'
        click_on 'Save'
        expect(page).to have_content 'New Candidate Drug Test Scheduling'
        expect(page).to have_content 'The date entered could not be used - there may be a typo or invalid date. Please re-enter'
        expect(CandidateDrugTest.count).to eq(0)
      end
    end
  end
end