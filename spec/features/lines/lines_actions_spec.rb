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