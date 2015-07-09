  require 'rails_helper'

  describe 'Line Assigned to Device' do
    let(:it_tech) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    let(:line) {create :line}
    # let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
    # let(:description) { 'TestDescription' }
    # let(:permission_index) { Permission.new key: 'line_index', permission_group: permission_group, description: description }
    # let(:permission_new) { Permission.new key: 'line_new', permission_group: permission_group, description: description }
    # let(:permission_update) { Permission.new key: 'line_update', permission_group: permission_group, description: description }
    # let(:permission_edit) { Permission.new key: 'line_edit', permission_group: permission_group, description: description }
    # let(:permission_destroy) { Permission.new key: 'line_destroy', permission_group: permission_group, description: description }
    # let(:permission_create) { Permission.new key: 'line_create', permission_group: permission_group, description: description }
    # let(:permission_show) { Permission.new key: 'line_show', permission_group: permission_group, description: description }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
    end
    it 'should have assign device button' do
      visit line_path(line)
      expect(page).to have_link('Assign Line to Device')
    end
  end