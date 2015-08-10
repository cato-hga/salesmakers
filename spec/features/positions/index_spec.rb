require 'rails_helper'

describe 'positions index' do
  let!(:it_tech) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position, permissions: [position_index], hq: true }
  let!(:position_two) { create :position, name: 'Position Two', department: position.department }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:position_index) { Permission.new key: 'position_index', permission_group: permission_group, description: description }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
    visit department_positions_path(position.department)
  end

  it 'shows the position name' do
    expect(page).to have_content position.name
    expect(page).to have_content position_two.name
  end

  it 'shows the department for the position' do
    expect(page).to have_content position_two.department.name
  end
end