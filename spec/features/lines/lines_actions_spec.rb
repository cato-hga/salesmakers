require 'rails_helper'

describe 'actions on Lines' do
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

  describe 'GET swap', js: true do
    before {
      visit swap_lines_path
      click_on 'Add'
    }
    it 'allows the user to add multiple rows' do
      expect(page).to have_css('div .serial_field', count: 2)
    end

    it 'should change the Add button to Delete for all but the last row' do
      within('#lines .row:first-of-type') do
        expect(page).to have_selector('.delete_row')
      end
      within('#lines .row:last-of-type') do
        expect(page).to have_selector('.add_row')
      end
    end

    it 'allows the user to delete extra rows' do
      click_on 'Delete'
      expect(page).to have_css('div .serial_field', count: 1)
    end
  end
end