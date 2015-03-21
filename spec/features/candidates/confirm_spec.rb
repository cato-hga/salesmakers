require 'rails_helper'

describe 'confirming details' do
  let!(:candidate) { create :candidate, location_area: location_area, state: 'FL' }
  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_create, permission_index] }
  let!(:location_area) { create :location_area }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission_create) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_index) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  let!(:reason) { create :training_unavailability_reason }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit confirm_candidate_path(candidate)
    select 'Male', from: 'Gender'
    select 'XL', from: 'Shirt size'
  end

  describe 'someone available for training' do
    before { select 'Yes', from: 'Is the candidate able to attend the training?' }

    it 'successfully redirects to candidate show' do
      click_on 'Confirm and Save'
      expect(page).to have_content('Please send now manually')
    end
  end

  describe 'someone unavailable for training', js: true do
    before do
      select 'No', from: 'Is the candidate able to attend the training?'
      select reason.name, from: 'Why not?'
    end

    it 'successfully redirects to candidate show' do
      click_on 'Confirm and Save'
      expect(page).to have_content('Please send now manually')
    end
  end
end