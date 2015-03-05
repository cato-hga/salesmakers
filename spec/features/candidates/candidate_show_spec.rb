require 'rails_helper'

describe 'candidate show page' do
  let!(:candidate) { create :candidate, location_area: location_area }
  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission] }
  let!(:location_area) { create :location_area }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit candidate_path(candidate)
  end

  it 'should have the proper page title' do
    expect(page).to have_selector('h1', text: candidate.name)
  end
end