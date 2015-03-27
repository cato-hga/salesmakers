require 'rails_helper'

describe 'Sprint PreTraining Welcome calls' do

  let!(:candidate) { create :candidate,
                            location_area: location_area,
                            training_availability: training_availability,
                            status: :paperwork_completed_by_advocate }
  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission, permission_two] }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_two) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }
  let!(:location_area) { create :location_area, location: location }
  let(:location) { create :location, sprint_radio_shack_training_location: training_location }
  let(:training_location) { create :sprint_radio_shack_training_location, latitude: 40, longitude: 50 }
  let!(:training_availability) { create :training_availability }
  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit candidate_path(candidate)
  end

  it 'is accessed from the candidate show page after the candidate is onboarded' do
    expect(page).to have_content 'Welcome Call'
  end

  it 'contains all relevant fields' do
    click_on 'Welcome Call'
    expect(page).to have_content 'Is the candidate still available for training?'
    expect(page).to have_content 'Apps needed on phone:'
    expect(page).to have_content 'GroupMe (Social Network)'
    expect(page).to have_content 'LifeSize Cloud (Video Calls)'
    expect(page).to have_content 'E-Pay (TimeKeeping)'
    expect(page).to have_content 'Reviewed w/ SalesMaker'
    expect(page).to have_content 'Confirmed Download'
    expect(page).to have_content 'Comment'
  end

  context 'when still available for training, and download at the same time' do
    before(:each) do
      click_on 'Welcome Call'
      select 'Yes', from: 'Is the candidate still available for training?'
      check :group_me_reviewed
      check :group_me_confirmed
      check :cloud_reviewed
      check :cloud_confirmed
      check :epay_reviewed
      check :epay_confirmed
      fill_in 'Comment', with: 'Test'
      click_on 'Save'
    end
    it 'does not update the training availability for the candidate' do
      expect(candidate.training_availability).to eq(training_availability)
    end
    it 'sets the completed status when fully completed' do
      welcome_call = SprintPreTrainingWelcomeCall.first
      expect(welcome_call.status).to eq('completed')
    end
    it 'assigns the correct attributes' do
      welcome_call = SprintPreTrainingWelcomeCall.first
      expect(welcome_call.still_able_to_attend).to eq(true)
      expect(welcome_call.group_me_reviewed).to eq(true)
      expect(welcome_call.group_me_confirmed).to eq(true)
      expect(welcome_call.cloud_reviewed).to eq(true)
      expect(welcome_call.cloud_confirmed).to eq(true)
      expect(welcome_call.epay_reviewed).to eq(true)
      expect(welcome_call.epay_confirmed).to eq(true)
      expect(welcome_call.epay_confirmed).to eq(true)
      expect(welcome_call.comment).to eq('Test')
      expect(welcome_call.candidate).to eq(candidate)
    end
    it 'redirects to the candidate page' do
      expect(page).to have_content 'Progress'
    end
    it 'shows a success message' do
      expect(page).to have_content 'Welcome Call Completed'
    end
    it 'creates a log entry' do
      #on show
      expect(page).to have_content 'Completed the Welcome Call for'
    end
    it 'does not show the welcome button' do
      within('header h1') do
        expect(page).not_to have_content 'Welcome Call'
      end
    end
  end
  context 'when not available for training' do
    let!(:reason) { create :training_unavailability_reason }
    before(:each) do
      Capybara.ignore_hidden_elements = false
      click_on 'Welcome Call'
      select 'No', from: 'Is the candidate still available for training?'
    end
    after(:each) do
      Capybara.ignore_hidden_elements = true
    end
    it 'requires the reason to be set' do
      click_on 'Save'
      expect(page).to have_content 'A reason must be selected'
    end
    it 'updates the training availability for the candidate' do
      select reason.name, from: 'Why not?'
      fill_in 'Comment', with: 'Test'
      click_on 'Save'
      candidate.reload
      expect(candidate.training_availability.able_to_attend).to eq(false)
    end
    it 'sets the correct reason as to why the candidate is unavailable' do
      select reason.name, from: 'Why not?'
      fill_in 'Comment', with: 'Test'
      click_on 'Save'
      candidate.reload
      expect(candidate.training_availability.training_unavailability_reason).to eq(reason)
    end
    it 'redirects to the candidate page' do
      select reason.name, from: 'Why not?'
      fill_in 'Comment', with: 'Test'
      click_on 'Save'
      expect(page).to have_content 'Progress'
    end
    it 'shows a success message' do
      select reason.name, from: 'Why not?'
      fill_in 'Comment', with: 'Test'
      click_on 'Save'
      expect(page).to have_content 'Welcome Call Completed'
    end
    it 'creates a log entry for welcome call' do
      #on show
      select reason.name, from: 'Why not?'
      fill_in 'Comment', with: 'Test'
      click_on 'Save'
      expect(page).to have_content 'Completed the Welcome Call for'
    end
  end
  context 'when available, but not able to download at the same time' do
    before(:each) do
      click_on 'Welcome Call'
      select 'Yes', from: 'Is the candidate still available for training?'
      check :group_me_reviewed
      check :epay_reviewed
      check :cloud_reviewed
      fill_in 'Comment', with: 'Test'
      click_on 'Save'
    end
    it 'allows the fields to be saved without all being filled out' do
      expect(SprintPreTrainingWelcomeCall.count).to eq(1)
    end
    it 'saves the first set of data' do
      welcome_call = SprintPreTrainingWelcomeCall.first
      expect(welcome_call.still_able_to_attend).to eq(true)
      expect(welcome_call.group_me_reviewed).to eq(true)
      expect(welcome_call.group_me_confirmed).to eq(false)
      expect(welcome_call.cloud_reviewed).to eq(true)
      expect(welcome_call.cloud_confirmed).to eq(false)
      expect(welcome_call.epay_reviewed).to eq(true)
      expect(welcome_call.epay_confirmed).to eq(false)
      expect(welcome_call.comment).to eq('Test')
      expect(welcome_call.candidate).to eq(candidate)
    end
    it 'still shows the button on candidate show' do
      within('header h1') do
        expect(page).to have_content 'Welcome Call'
      end
    end
    it 'sets the welcome_call_started_status' do
      welcome_call = SprintPreTrainingWelcomeCall.first
      expect(welcome_call.status).to eq('started')
    end
    it 'creates a log entry' do
      expect(page).to have_content 'Started the Welcome Call for'
    end
  end
end