require 'rails_helper'

describe 'Sprint PreTraining Welcome calls' do

  let!(:candidate) { create :candidate, status: :onboarded }
  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission, permission_two] }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_two) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit candidate_path(candidate)
  end

  it 'is accessed from the candidate show page after the candidate is onboarded' do
    expect(page).to have_content 'Welcome Call'
  end
  it 'contains all relevant fields'
  context 'when still available for training, and download at the same time' do
    it 'allows for selection of groupme, epay, and cloud fields'
    it 'allows the fields to be saved without all being filled out'
    it 'does not update the training availability for the candidate'
    it 'sets the complete boolean when fully completed'
    it 'sets the welcome_call_complete status'
  end
  context 'when not available for training' do
    it 'requires the reason to be set'
    it 'updates the training availability for the candidate'
    it 'sets the correct reason as to why the candidate is unavailable'
  end
  context 'when available, but not able to download at the same time' do
    it 'saves the first set of data'
    it 'does not set the complete flag if not filled out'
    it 'still shows the button on candidate show'
    it 'keeps old information when accessed again'
    it 'sets the welcome_call_started_status'
  end
  context 'form failure' do
    it 'shows error messages'
    it 'does not create a record'
  end
end