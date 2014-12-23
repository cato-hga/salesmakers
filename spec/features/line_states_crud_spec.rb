require 'rails_helper'

describe 'LineStates CRUD actions' do

  context 'for creating' do
    let(:line_state) { build :line_state }

    subject {
      visit line_states_path
      within '#main_container h1' do
        click_on 'new_action_button'
      end
      fill_in 'Name', with: line_state.name
      click_on 'Save'
    }

    it 'has the correct page title' do
      visit new_line_state_path
      expect(page).to have_selector('h1', text: 'New Line State')
    end

    it 'creates a new line state' do
      subject
      expect(page).to have_content(line_state.name)
    end

    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end
  end

  context 'for reading' do
    let!(:line_state) { create :line_state }

    it 'navigates to the line states index' do
      visit lines_path
      within '#main_container header h1' do
        click_on 'Edit States'
      end
      expect(page).to have_content(line_state.name)
    end
  end

  context 'for updating' do
    context 'unlocked line states' do
      let!(:line_state) { create :line_state }
      let(:new_name) { 'New Name' }

      subject {
        visit line_states_path
        click_on line_state.name
        fill_in 'Name', with: new_name
        click_on 'Save'
      }

      it 'edits an unlocked line state' do
        subject
        expect(page).to have_content(new_name)
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end

    end

    context 'locked line states' do
      let!(:line_state) { create :line_state, locked: true }

      it 'shows no link for a locked line state' do
        visit line_states_path
        expect(page).not_to have_selector('a', text: line_state.name)
      end
    end
  end

  context 'for destroying', js: true do
    let!(:line_state) { create :line_state }
    let(:line) { create :line }

    subject do
      visit line_states_path
      click_on line_state.name
      page.driver.browser.accept_js_confirms
      within '#main_container header h1' do
        click_on 'delete_action_button'
      end
    end

    it 'destroys a line state' do
      subject
      visit line_states_path
      expect(page).not_to have_content(line_state.name)
    end

    it 'destroys each association of a line with a destroyed line state' do
      line.line_states << line_state
      subject
      visit lines_path
      expect(page).not_to have_content(line_state.name)
    end
  end
end