require 'rails_helper'

describe 'confirming details' do
  let!(:candidate) { create :candidate, location_area: location_area, state: 'FL' }
  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_create, permission_index] }
  let!(:location_area) { create :location_area, location: location }
  let(:location) { create :location, sprint_radio_shack_training_location: training_location }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission_create) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_index) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  let!(:reason) { create :training_unavailability_reason }
  let(:training_location) { create :sprint_radio_shack_training_location }
  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit confirm_candidate_path(candidate)
    select 'Male', from: 'Gender'
    select 'XL', from: 'Shirt size'
  end

  it 'contains the candidates training location' do
    expect(page).to have_content 'Training Location'
    expect(page).to have_content training_location.name
    expect(page).to have_content training_location.address
    expect(page).to have_content training_location.room
  end

  describe 'someone available for training' do
    before {
      select 'Yes', from: 'Is the candidate able to attend the training?'
      click_on 'Confirm and Save'
    }

    it 'successfully redirects to candidate show' do
      expect(page).to have_content('Please send now manually')
    end

    it 'updates the candidate' do
      candidate.reload
      expect(candidate.shirt_size).to eq('XL')
      expect(candidate.shirt_gender).to eq('Male')
      expect(candidate.training_availability.able_to_attend).to eq(true)
    end

  end

  describe 'someone unavailable for training', js: true do
    before do
      select 'No', from: 'Is the candidate able to attend the training?'
      select reason.name, from: 'Why not?'
      #fill_in 'Comments', with: 'Test'
      click_on 'Confirm and Save'
    end

    it 'successfully redirects to candidate show' do
      expect(page).to have_content('Please send now manually')
    end
  end
end