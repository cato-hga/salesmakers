require 'rails_helper'

describe 'candidate show page' do
  let!(:candidate) { create :candidate, location_area: location_area }
  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission] }
  let!(:location_area) { create :location_area }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  let!(:candidate_contact) {
    create :candidate_contact,
           candidate: candidate,
           person: recruiter,
           contact_method: :phone,
           notes: 'This is a sample note'
  }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit candidate_path(candidate)
  end

  it 'should have the proper page title' do
    expect(page).to have_selector('h1', text: candidate.name)
  end

  it 'should show states of completion' do
    expect(page).to have_content('INCOMPLETE')
  end

  it 'should show the contact log' do
    expect(page).to have_content(candidate_contact.notes)
  end
end