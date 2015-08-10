require 'rails_helper'

describe GlobalSearchController do
  let!(:it_tech) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position, permissions: [device_index, line_index, candidate_index], hq: true }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:device_index) { Permission.new key: 'device_index', permission_group: permission_group, description: description }
  let(:line_index) { Permission.new key: 'line_index', permission_group: permission_group, description: description }
  let(:candidate_index) { Permission.new key: 'candidate_index', permission_group: permission_group, description: description }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
  end

  describe 'GET results' do
    before do
      post :results,
           global_search: 'Foobar'
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the results template' do
      expect(response).to render_template(:results)
    end
  end

end