require 'rails_helper'
require 'apis/workmarket_api'

describe WorkmarketAPI do
  let!(:project) { create :project, workmarket_project_num: '10005' }
  let(:workmarket_api) { described_class.new }
  let(:assignment_json) { workmarket_api.get_assignment_json '7570091574' }

  it 'gets a list of completed assignments', :vcr do
    expect(workmarket_api.get_completed_assignments).not_to be_empty
  end

  it 'gets an assignment', :vcr do
    assignment = workmarket_api.get_assignment assignment_json
    expect(assignment).to be_instance_of(WorkmarketAssignment)
    expect(assignment).to be_valid
  end

  it 'gets a list of attachments for an assignment', :vcr do
    attachments = workmarket_api.get_attachments assignment_json
    expect(attachments.count).to eq(7)
  end

  it 'gets a list of custom fields for an assignment', :vcr do
    custom_fields = workmarket_api.get_custom_fields assignment_json
    expect(custom_fields.count).to eq(14)
  end

  it 'gets a list of clients', :vcr do
    clients = workmarket_api.get_clients
    expect(clients).not_to be_empty
  end

  it 'gets a list of locations', :vcr do
    client = workmarket_api.get_clients[0]
    locations = workmarket_api.get_locations client.workmarket_client_num
    expect(locations).not_to be_empty
  end
end