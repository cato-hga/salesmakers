require 'rails_helper'

describe 'sending Docusign paperwork' do
  let!(:candidate) { create :candidate, location_area: location_area, state: 'FL' }
  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_create, permission_index] }
  let!(:location_area) { create :location_area, area: area, priority: 1 }
  let(:area) { create :area, project: project }
  let(:project) { create :project, name: 'Sprint Postpaid' }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission_create) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_index) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  before { CASClient::Frameworks::Rails::Filter.fake(recruiter.email) }

  it 'sends the paperwork when the envelope successfully sends', :vcr do
    docusign_template = create :docusign_template,
                               template_guid: 'BCDA79DF-21E1-4726-96A6-AC2AAD715BB5',
                               state: 'FL',
                               project: location_area.area.project,
                               document_type: 0
    expect {
      visit send_paperwork_candidate_path(candidate)
    }.to change(JobOfferDetail, :count).by(1)
    expect(page).to have_content('Paperwork sent')
    expect(page).to have_content(candidate.name)
  end

  it 'does not send the paperwork but still saves job offer details upon failure' do
    expect {
      visit send_paperwork_candidate_path(candidate)
    }.to change(JobOfferDetail, :count).by(1)
    expect(page).to have_content('Paperwork sent successfully.')
    expect(page).to have_content(candidate.name)
  end

  it 'assigns the candidate the NCLB Training Session Status', :vcr do
    docusign_template = create :docusign_template,
                               template_guid: 'BCDA79DF-21E1-4726-96A6-AC2AAD715BB5',
                               state: 'FL',
                               project: location_area.area.project,
                               document_type: 0
    visit send_paperwork_candidate_path(candidate)
    candidate.reload
    expect(candidate.training_session_status).to eq("nclb")
  end
end
