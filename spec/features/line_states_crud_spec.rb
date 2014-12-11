require 'rails_helper'

describe 'LineStates CRUD actions' do

  context 'for creating' do
    let(:line_state) { build :line_state }

    it 'has the correct page title' do
      visit new_line_state_path
      expect(page).to have_selector('h1', text: 'New Line State')
    end

    it 'creates a new line state' do
      visit line_states_path
      within '#main_container h1' do
        click_on 'new_action_button'
      end
      fill_in 'Name', with: line_state.name
      click_on 'Save'
      expect(page).to have_content(line_state.name)
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

end