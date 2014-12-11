require 'rails_helper'

describe 'LineStates CRUD actions' do

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