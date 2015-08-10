require 'rails_helper'

describe 'editing position permissions' do
  let!(:it_tech) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position, permissions: [position_index, position_update], hq: true }
  let!(:position_two) { create :position, name: 'Position Two', department: position.department }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:position_index) { Permission.new key: 'position_index', permission_group: permission_group, description: "view index" }
  let(:position_update) { Permission.new key: 'position_update', permission_group: permission_group, description: "update records" }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
    visit department_positions_path(position.department)
    click_on position_two.name
  end

  it 'shows each permission group in its own widget' do
    expect(page).to have_selector('h3', text: permission_group.name)
  end

  it 'shows each permission description' do
    expect(page).to have_selector('label', text: position_index.description)
  end

  describe 'saving permissions' do
    it 'saves a new permission' do
      find("input[value='#{position_index.id}']").set true
      expect {
        click_on 'Save'
        position_two.reload
      }.to change(position_two.permissions, :count).by(1)
      expect(position_two.permissions).to include(position_index)
    end

    it 'removes an unchecked permission' do
      position_two.permissions << position_index
      visit edit_permissions_department_position_path(position_two.department, position_two)
      find("input[value='#{position_index.id}']").set false
      expect {
        click_on 'Save'
        position_two.reload
      }.to change(position_two.permissions, :count).by(-1)
      expect(position_two.permissions).not_to include(position_index)
    end
  end

end