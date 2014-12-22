require 'rails_helper'

describe 'Lines NON-CRUD actions' do
  context 'for line states' do
    let(:line) { create :line }
    let!(:locked_line_state) {
      create :line_state,
             name: 'Locked',
             locked: true
    }
    let!(:unlocked_line_state) {
      create :line_state,
             name: 'Unlocked',
             locked: false
    }

    it 'allows an unlocked line state to be removed' do
      line.line_states << unlocked_line_state
      visit line_path(line)
      find('.line_state a.remove').click
      expect(page).not_to have_selector('.line_state', text: unlocked_line_state.name)
    end

    it 'does not allow a locked line state to be removed' do
      line.line_states << locked_line_state
      visit line_path(line)
      expect(page).not_to have_selector('.line_state a.remove')
    end

    it 'adds an unlocked line state' do
      visit line_path(line)
      within '.line_states' do
        select unlocked_line_state.name, from: 'add_line_state_select'
        click_on '+'
      end
      expect(page).to have_selector('.line_state', text: unlocked_line_state.name)
    end

    it 'does not allow a locked line state to be added' do
      visit line_path(line)
      within '.line_states' do
        expect(page).not_to have_selector('option', text: locked_line_state.name)
      end
    end
  end

  context 'for deactivation', js: true do
    let(:active_state) { create :line_state, name: 'Active', locked: true }
    let(:line) {
      new_line = create :line
      new_line.line_states << active_state
      new_line
    }
    let!(:device) { create :device, line: line }

    subject {
      visit line_path(line)
      page.driver.browser.accept_js_confirms
      within '#main_container header' do
        click_on 'Deactivate'
      end
    }

    it 'deactivates a line' do
      subject
      visit lines_path
      expect(page).not_to have_selector('a', text: 'Active')
    end

    it 'detaches a line from a device' do
      subject
      visit device_path(device)
      expect(page).not_to have_content(line.identifier)
    end

    context 'from device#show' do
      it 'deactivates and detaches the line' do
        visit device_path(device)
        page.driver.browser.accept_js_confirms
        within 'p#line' do
          click_on 'Deactivate'
        end
        visit device_path(device)
        within 'p#line' do
          expect(page).not_to have_content('Active')
        end
      end
    end
  end

  describe 'GET swap' do
    it 'allows the user to add multiple rows'
    it 'allows the user to delete extra rows'
  end

  describe 'PATCH update' do
    let(:old_line) { create :line }
    let!(:new_line) { create :line, identifier: '5555555555' }
    let(:device) { create :device, line: old_line }
    subject {
      visit swap_lines_path
      within('#lines') do
        within all('.row').first do
          find('.serial_field').set(device.serial)
          find('.line_field').set(new_line.identifier)
        end
      end
      click_on 'Swap'
    }
    it 'swaps the line' do
      subject
      device.reload
      expect(device.line).to eq(new_line)
      expect(device.line).not_to eq(old_line)
    end

    it 'redirects to the lines index page' do
      subject
      expect(page).to have_content(new_line.identifier)
      expect(page).not_to have_content('New Line')
    end
  end
end