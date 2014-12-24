require 'rails_helper'

describe 'Lines CRUD actions' do

  describe 'GET index' do
    let(:line) { create :line }
    let!(:device) { create :device, line: line }

    before {
      visit lines_path
    }

    it 'contains a link to lines#new' do
      expect(page).to have_link('New')
    end

    it 'contains a link to lines#line_swap' do
      expect(page).to have_link('Swap Lines')
    end

    it 'shows the device serial a line is attached to' do
      expect(page).to have_content device.serial
    end
  end

  describe 'GET show' do
    let(:line) { create :line }
    let(:device) { create :device, line: line }
    let!(:device_deployment) { create :device_deployment, device: device }

    before { visit line_path line }

    it 'displays the contract end date' do
      expect(page).to have_content(line.contract_end_date.strftime '%m/%d/%Y')
    end

    it 'displays the device serial the line is attached to' do
      expect(page).to have_content(device.serial)
    end

    it 'displays the person the device is attached to' do
      expect(page).to have_content(device_deployment.person.display_name)
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
