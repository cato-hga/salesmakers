require 'rails_helper'

describe 'Swapping lines' do
  let(:person) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position, permissions: [permission_update] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_update) { Permission.new key: 'device_update',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let!(:device) { create :device }
  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit swap_line_device_path device
    end

    it 'shows the You are not authorized page' do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do
    let(:line_state) { LineState.find_or_initialize_by name: 'Active' }
    let!(:line) { create :line, identifier: '7274985180', line_states: [line_state] }
    let!(:second_line) { create :line, identifier: '7274985181', line_states: [line_state] }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit swap_line_device_path device
    end

    it 'displays the index of lines, with the option to "Swap"' do
      expect(page).to have_content('(727) 498-5180')
      expect(page).to have_content('(727) 498-5181')
      within('#line_swap_table') do
        expect(page).to have_content('Swap Line') #SCOPE THIS W/ CAPYBARA
      end
    end
  end

  describe 'when only one line has a device (base behavior)' do
    let(:line_state) { LineState.find_or_initialize_by name: 'Active' }
    let!(:line) { create :line, identifier: '7274985180', line_states: [line_state] }
    let!(:second_line) { create :line, identifier: '7274985181', line_states: [line_state] }
    let(:device_with_line) { create :device, line: line, serial: '215899', identifier: '215899' }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit swap_line_device_path device_with_line
      within all(:css, 'tr').last do
        click_on 'Swap Line'
      end
    end
    describe 'the swap results page' do
      it 'prompts the user to pick between deactivated the swapped line or keeping it active' do
        expect(page).to have_content('Swap Results')
        expect(page).to have_content("Do you want to deactivate the device's original line or keep it active?")
      end
      it 'shows deactivation information', pending: 'fuck this' do
        click_on "Deactivate #{line.identifier}"
        wait_until { find('deactivateModal') }
        expect(page).to have_content('7274985180 will be removed from 215899 and marked as inactive')
        expect(page).to have_content('7274985181 will be moved to 215899')
        expect(page).to have_content('Confirm Swap')
      end
      it 'shows keeping active information'

    end
    describe 'when both lines have devices' do
      it 'swaps the line' do
        visit device_path device_with_line
        expect(page).to have_content(second_line.identifier)
      end
      it 'creates log entries on both devices'
    end
  end


  describe 'end results page' do
    it 'contains the list of changes'
  end

  describe 'submission success' do
    it 'shows a confirmation'
  end

  describe 'submission failure' do
    it 'shows error messages'
  end
end