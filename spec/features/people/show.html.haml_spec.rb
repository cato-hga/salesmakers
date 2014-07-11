require 'rails_helper'

feature 'Person show' do
  scenario 'When a persons profile is loaded, a p&l widget should show' do

    visit 'person#show'
    save_and_open_page

    within '.inner', visible: false do
      expect(page).to have_content 'P&L'
    end
  end
end
