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
end
