require 'rails_helper'

describe 'Adding a Line to a Device' do
  let(:it_tech) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position, permissions: [permission_update, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_update) { Permission.new key: 'device_update', permission_group: permission_group, description: description }
  let(:permission_index) { Permission.new key: 'device_index', permission_group: permission_group, description: description }
  let(:line) { create :line, line_states: [line_state] }
  let(:line_state) { create :line_state, name: 'Active' }
  let!(:line_with_device) { create :line, device: device }
  let(:device) { create :device }
  let!(:device_without_line_one) { create :device, line: nil }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
  end

  describe 'The Show Page' do
    it 'should show an assign device button for an active line without a device' do
      visit line_path(line)
      expect(page).to have_link('Assign Line to Device')
    end

    it 'should direct to line edit devices page' do
      visit line_path(line)
      click_on 'Assign Line to Device'
      expect(page.current_path).to eq line_edit_devices_path(line)
    end
  end
  context 'Line with a Device Attached' do

    it 'should not show an assign device button' do
      visit line_path(line_with_device)
      expect(page).not_to have_link('Assign Line to Device')
    end
  end

  describe 'The Line Edit Page' do
    let!(:device_without_line_two) { create :device, line: nil }
    let!(:device_without_line_three) { create :device, line: nil }
    before(:each) do
      visit line_edit_devices_path(line)
    end
    it 'should show the specific line number' do
      line_string = line.identifier
      expect(page).to have_content("Assign a Device to Line #{'(' + line_string[0..2] + ') ' + line_string[3..5] + '-' + line_string[6..9]
                                   }")
    end
    it 'should display devices without a line attached' do
      expect(page).to have_content(device_without_line_one.serial)
      expect(page).to have_content(device_without_line_two.serial)
      expect(page).to have_content(device_without_line_three.serial)
    end
    it 'should have an assign line button ' do
      expect(page).to have_button('Assign Line', count: 3)
    end
  end

  describe 'Assign a line' do
    before(:each) do
      visit line_edit_devices_path(line)
      click_on 'Assign Line'
    end
    it 'assigns to a line' do
      line_string = line.identifier
      within "p#line" do
        expect(page).to have_content('(' + line_string[0..2] + ') ' + line_string[3..5] + '-' + line_string[6..9])
      end
    end

    it 'redirects to device_path' do
      expect(current_path).to eq(device_path(device_without_line_one))
    end

    it 'flashes success message' do
      expect(page).to have_content('Successfully assigned line to device!')
    end

    it 'creates log entries' do
      line_string = line.identifier
      within ".history" do
        expect(page).to have_content("Assigned Line #{'(' + line_string[0..2] + ') ' + line_string[3..5] + '-' + line_string[6..9]}")
      end
    end
  end
end