require 'rails_helper'

describe 'Swapping lines' do
  include LinksHelperExtension

  let!(:person) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position, permissions: [permission_update, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_update) { Permission.new key: 'device_update',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'device_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }

  describe 'for unauthorized users' do
    let(:device) { create :device }
    let(:unauth_person) { create :person }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit line_swap_or_move_device_path device
    end

    it 'shows the You are not authorized page' do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do
    let!(:device_one) { create :device, line: line }
    let(:line) { create :line }
    let(:second_line) { create :line }
    let!(:device_two) { create :device, line: second_line }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit line_swap_or_move_device_path device_one
    end

    it 'displays the index of devices, with the option to "Swap"' do
      expect(page).to have_content(line_display(line))
      expect(page).to have_content(line_display(second_line))
      within('#line_swap_table') do
        expect(page).to have_content('Swap Line')
      end
    end

    describe 'the swap results page' do
      it 'shows the swap' do
        within all('tr').last do
          click_on 'Swap Line'
        end
        expect(page).to have_content("#{line_display(line)} will be removed from #{device_one.identifier} and replaced by #{line_display(second_line)}")
        expect(page).to have_content("#{line_display(second_line)} will be removed from #{device_two.identifier} and replaced by #{line_display(line)}")
        expect(page).to have_button('Confirm Swap')
      end
    end

    describe 'submission success' do
      before(:each) do
        within all('tr').last do
          click_on 'Swap Line'
        end
        within('#swap_results') do
          click_on('Confirm Swap')
        end
      end

      it 'shows a confirmation' do
        expect(page).to have_content 'Lines swapped!'
      end
      it 'shows swapped lines' do
        expect(page).to have_content("Line: #{line_display(second_line)}")
        visit device_path device_two
        expect(page).to have_content("Line: #{line_display(line)}")
      end
      it 'redirects to the original device' do
        within('header h1') do
          expect(page).to have_content device_one.serial
        end
      end
      it 'creates log entries' do
        within('.history') do
          expect(page).to have_content "Swapped the device's line from #{line_display(line)}"
        end
        visit device_path device_two
        within('.history') do
          expect(page).to have_content "Swapped the device's line from #{line_display(second_line)}"
        end
      end
    end

    describe 'submission failure' do
      it 'renders the swap page', pending: 'Should this be tested?'
      it 'shows error messages', pending: 'Should this be tested?'
    end
  end
end


# describe 'Moving lines' do
#   let!(:person) { create :it_tech_person, position: position }
#   let(:position) { create :it_tech_position, permissions: [permission_update, permission_index] }
#   let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
#   let(:permission_update) { Permission.new key: 'device_update',
#                                            permission_group: permission_group,
#                                            description: 'Test Description' }
#   let(:permission_index) { Permission.new key: 'device_index',
#                                           permission_group: permission_group,
#                                           description: 'Test Description' }
#
#   describe 'for unauthorized users' do
#     let!(:device) { create :device }
#     let(:unauth_person) { create :person }
#     before(:each) do
#       CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
#       visit line_swap_or_move_device_path device
#     end
#
#     it 'shows the You are not authorized page' do
#       expect(page).to have_content('Your access does not allow you to view this page')
#     end
#   end
#
#   describe 'when only one line has a device (base behavior)' do
#     let(:line_state) { LineState.find_or_initialize_by name: 'Active' }
#     let!(:line) { create :line, line_states: [line_state] }
#     let!(:second_line) { create :line, line_states: [line_state] }
#     let(:device_with_line) { create :device, line: line }
#     before(:each) do
#       CASClient::Frameworks::Rails::Filter.fake(person.email)
#       visit line_swap_or_move_device_path device_with_line
#       within all('tr').last do
#         click_on 'Swap Line'
#       end
#     end
#
#     describe 'the swap results page' do
#       it 'prompts the user to pick between deactivated the swapped line or keeping it active' do
#         expect(page).to have_content('Swap Results')
#         expect(page).to have_content("Do you want to deactivate the device's original line or keep it active?")
#       end
#       it 'shows deactivation information', js: true do
#         Capybara.ignore_hidden_elements = false
#         click_on "Deactivate #{line.identifier}"
#         expect(page).to have_css('div#swap_results_deactivate.widget.visible')
#         expect(page).to have_css('div#swap_results_keep_active.widget.hidden')
#         expect(page).to have_content("#{line.identifier} will be removed from #{device.serial} and marked as inactive")
#         expect(page).to have_content("#{second_line.identifier} will be moved to #{device.serial}")
#         expect(page).to have_content('Confirm Swap')
#         Capybara.ignore_hidden_elements = true
#       end
#
#       it 'shows keeping active information', js: true do
#         Capybara.ignore_hidden_elements = false
#         click_on "Keep #{line.identifier} Active"
#         expect(page).to have_css('div#swap_results_deactivate.widget.hidden')
#         expect(page).to have_css('div#swap_results_keep_active.widget.visible')
#         expect(page).to have_content("#{line.identifier} will be removed from #{device.serial} and NOT marked as inactive")
#         expect(page).to have_content("#{second_line.identifier} will be moved to #{device.serial}")
#         expect(page).to have_content('Confirm Swap')
#         Capybara.ignore_hidden_elements = true
#       end
#     end
#
#     describe 'submission success' do #This is NOT testing the activate/deactivate. This assumes the old line is deactivated
#       before(:each) do
#         click_on "Deactivate #{line.identifier}"
#         within('#swap_results_deactivate') do
#           click_on('Confirm Swap')
#         end
#       end
#       it 'shows a confirmation' do
#         expect(page).to have_content 'Line(s) swapped!'
#       end
#       it 'redirects to the original device' do
#         within('header h1') do
#           expect(page).to have_content device_with_line.serial
#         end
#       end
#       it 'creates a log entry' do
#         within('.history') do
#           expect(page).to have_content "Swapped the device's line from #{line.identifier}"
#         end
#       end
#     end
#
#     describe 'submission failure' do
#       it 'renders the swap page', pending: 'Should this be tested?'
#       it 'shows error messages', pending: 'Should this be tested?'
#     end
#   end
#
# end