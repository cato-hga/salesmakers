require 'rails_helper'

describe 'Swapping lines' do
  let!(:person) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position, permissions: [permission_update, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_update) { Permission.new key: 'device_update',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'device_index',
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
      within all('tr').last do
        click_on 'Swap Line'
      end
    end
    describe 'the swap results page' do
      it 'prompts the user to pick between deactivated the swapped line or keeping it active' do
        expect(page).to have_content('Swap Results')
        expect(page).to have_content("Do you want to deactivate the device's original line or keep it active?")
      end
      it 'shows deactivation information', js: true do
        Capybara.ignore_hidden_elements = false
        click_on "Deactivate #{line.identifier}"
        expect(page).to have_css('div#swap_results_deactivate.widget.visible')
        expect(page).to have_css('div#swap_results_keep_active.widget.hidden')
        expect(page).to have_content('7274985180 will be removed from 215899 and marked as inactive')
        expect(page).to have_content('7274985181 will be moved to 215899')
        expect(page).to have_content('Confirm Swap')
        Capybara.ignore_hidden_elements = true
      end

      it 'shows keeping active information', js: true do
        Capybara.ignore_hidden_elements = false
        click_on "Keep #{line.identifier} Active"
        expect(page).to have_css('div#swap_results_deactivate.widget.hidden')
        expect(page).to have_css('div#swap_results_keep_active.widget.visible')
        expect(page).to have_content('7274985180 will be removed from 215899 and NOT marked as inactive')
        expect(page).to have_content('7274985181 will be moved to 215899')
        expect(page).to have_content('Confirm Swap')
        Capybara.ignore_hidden_elements = true
      end
    end

    describe 'submission success' do #This is NOT testing the activate/deactivate. This assumes the old line is deactivated
      before(:each) do
        click_on "Deactivate #{line.identifier}"
        within('#swap_results_deactivate') do
          click_on('Confirm Swap')
        end
      end
      it 'shows a confirmation' do
        expect(page).to have_content 'Line(s) swapped!'
      end
      it 'redirects to the original device' do
        within('header h1') do
          expect(page).to have_content device_with_line.serial
        end
      end
      it 'creates a log entry' do
        within('.history') do
          expect(page).to have_content "Swapped the device's line from #{line.identifier}"
        end
      end
    end

    describe 'submission failure' do
      it 'renders the swap page'
      it 'shows error messages'
    end
  end

  describe 'when both lines have devices' do
    let(:device_one) { create :device, line: line, serial: '215899', identifier: '215899' }
    let(:line_state) { LineState.find_or_initialize_by name: 'Active' }
    let!(:line) { create :line, identifier: '7274985180', line_states: [line_state] }
    let!(:second_line) { create :line, identifier: '7274985181', line_states: [line_state] }
    let(:device_two) { create :device, line: second_line }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit swap_line_device_path device_one
      within all('tr').last do
        click_on 'Swap Line'
      end
    end

    describe 'the swap results page' do
      it 'prompts the user to pick between deactivated the swapped line or keeping it active' do
        expect(page).to have_content('Swap Results')
        expect(page).to have_content("Do you want to deactivate the device's original line or keep it active?")
      end
      it 'shows deactivation information', js: true do
        Capybara.ignore_hidden_elements = false
        click_on "Deactivate #{line.identifier}"
        expect(page).to have_css('div#swap_results_deactivate.widget.visible')
        expect(page).to have_css('div#swap_results_keep_active.widget.hidden')
        expect(page).to have_content('7274985180 will be removed from 215899 and marked as inactive')
        expect(page).to have_content('7274985181 will be moved to 215899')
        expect(page).to have_content('Confirm Swap')
        Capybara.ignore_hidden_elements = true
      end

      it 'shows keeping active information', js: true do
        Capybara.ignore_hidden_elements = false
        click_on "Keep #{line.identifier} Active"
        expect(page).to have_css('div#swap_results_deactivate.widget.hidden')
        expect(page).to have_css('div#swap_results_keep_active.widget.visible')
        expect(page).to have_content('7274985180 will be removed from 215899 and NOT marked as inactive')
        expect(page).to have_content('7274985181 will be moved to 215899')
        expect(page).to have_content('Confirm Swap')
        Capybara.ignore_hidden_elements = true
      end
    end

    describe 'submission success' do
      it 'shows a confirmation'
      it 'redirects to the original device'
      it 'creates log entries'
    end

    describe 'submission failure' do
      it 'renders the swap page'
      it 'shows error messages'
    end
  end
end