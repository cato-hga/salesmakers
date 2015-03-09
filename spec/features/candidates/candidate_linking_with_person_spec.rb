require 'rails_helper'

describe 'linking a Candidate with a Person' do
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'candidate_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let(:position) {
    create :position,
           name: 'Advocate',
           permissions: [permission_create, permission_index],
           hq: true,
           all_field_visibility: true
  }
  let(:recruiter) { create :person, position: position }
  let!(:candidate) {
    create :candidate,
           latitude: 18.00,
           longitude: -66.40,
           project: area.project,
           location_area: location_area
  }
  let(:area) { create :area }
  let(:location) {
    create :location,
           latitude: 17.9857925,
           longitude: -66.3914388
  }
  let!(:location_area) {
    create :location_area,
           location: location,
           area: area,
           target_head_count: 2,
           potential_candidate_count: 1
  }
  let(:person) { create :person }

  subject do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit candidates_path
    click_on 'Link Person'
    fill_in 'q_email_cont', with: person.email
    first('.button[value="Select"]').click
  end

  it 'links the candidate with a person' do
    subject
    expect(page).to have_content('Successfully linked')
  end

  it 'updates the candidate status' do
    subject
    candidate.reload
    expect(candidate.status).to eq('onboarded')
  end

  it 'changes the location area potential candidate count' do
    expect {
      subject
      location_area.reload
    }.to change(location_area, :potential_candidate_count).from(1).to(0)
  end

  it 'changes the location area current head count' do
    expect {
      subject
      location_area.reload
    }.to change(location_area, :current_head_count).from(0).to(1)
  end
end