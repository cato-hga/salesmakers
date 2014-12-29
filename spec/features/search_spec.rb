require 'rails_helper'

describe 'searching' do

  context 'on Lines#index' do
    let!(:line) { create :line }

    it 'strips non-numeric characters from the identifier query' do
      visit lines_path
      fill_in 'q_unstripped_identifier_cont', with: line.identifier[0..2] + '-' + line.identifier[3..5]
      click_on 'search'

      display = '(' + line.identifier[0..2] + ') '
      display += line.identifier[3..5] + '-' + line.identifier[6..9]

      expect(page).to have_selector('a', text: display)
    end
  end

  context 'on Devices#index' do
    let!(:device) { create :device, line: create(:line) }

    before { visit devices_path }

    it 'strips non-numeric characters from the line identifier query' do
      identifier = device.line.identifier
      fill_in 'q_line_unstripped_identifier_cont', with: identifier[0..2] + '-' + identifier[3..5]
      click_on 'search'

      display = '(' + identifier[0..2] + ') '
      display += identifier[3..5] + '-' + identifier[6..9]

      expect(page).to have_selector('a', text: display)
    end

    it 'strips non-alphanumeric characters from the serial query' do
      serial = device.serial
      fill_in 'q_unstripped_serial_cont', with: serial[0..2] + '-' + serial[3..6]
      click_on 'search'
      expect(page).to have_selector('a', text: serial)
    end

    it 'strips non-alphanumeric characters from the identifier query' do
      identifier = device.identifier
      fill_in 'q_unstripped_identifier_cont', with: identifier[0..2] + '-' + identifier[3..6]
      click_on 'search'
      expect(page).to have_selector('a', text: identifier)
    end
  end
end