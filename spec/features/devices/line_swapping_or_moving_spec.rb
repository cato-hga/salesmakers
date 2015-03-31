require 'rails_helper'
include LinksHelperExtension

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
    let!(:device_one) { create :device, line: line, identifier: '123456' }
    let(:line) { create :line, identifier: '9876543210' }
    let(:second_line) { create :line, identifier: '8765432109' }
    let!(:device_two) { create :device, line: second_line, identifier: '632145' }
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
        sleep 1.second
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
      it 'shows error messages', pending: 'Build object and stub out'
    end
  end
end


describe 'Moving lines' do
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
    let!(:device_without_line) { create :device }
    let!(:line) { create :line, identifier: '9876543210' }
    let!(:device_with_line) { create :device, line: line }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit line_swap_or_move_device_path device_with_line
    end

    describe 'the move results page' do
      it 'shows the move' do
        within('#line_swap_table') do
          click_on 'Move Line to This Device'
        end
        expect(page).to have_content("#{line_display(line)} will be removed from #{device_with_line.identifier} and moved to #{device_without_line.identifier}")
        expect(page).to have_button('Confirm Move')
      end
    end


    describe 'submission success' do
      before(:each) do
        within('#line_swap_table') do
          click_on 'Move Line to This Device'
        end
        within('#swap_results') do
          click_on('Confirm Move')
        end
      end
      it 'shows a confirmation' do
        expect(page).to have_content 'Line moved!'
      end
      it 'redirects to the original device' do
        within('header h1') do
          expect(page).to have_content device_with_line.serial
        end
      end
      it 'creates log entries' do
        within('.history') do
          expect(page).to have_content "Removed line #{line_display line}"
        end
        visit device_path device_without_line
        within('.history') do
          expect(page).to have_content "Added line #{line_display line}"
        end
      end
    end


    describe 'submission failure' do
      it 'renders the swap page', pending: 'Should this be tested?'
      it 'shows error messages', pending: 'Build object and skip validation'
    end
  end


end