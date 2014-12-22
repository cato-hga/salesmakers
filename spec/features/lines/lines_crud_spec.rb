require 'rails_helper'

describe 'Lines CRUD actions' do

  describe 'GET index' do
    before {
      visit lines_path
    }

    it 'contains a link to lines#new' do
      expect(page).to have_link('New')
    end

    it 'contains a link to lines#line_swap' do
      expect(page).to have_link('Swap Lines')
    end
  end

  describe 'GET show' do
    let(:line) { create :line }
    before { visit line_path line }
    it 'displays the contract end date' do
      expect(page).to have_content(line.contract_end_date.strftime '%m/%d/%Y')
    end
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
      expect(page).to have_content('(555) 555-5555')
      expect(page).not_to have_content('New Line')
    end
  end
end
