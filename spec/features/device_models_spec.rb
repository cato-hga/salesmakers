require 'rails_helper'

describe 'DeviceModels spec' do

  describe 'index' do
    let!(:device) { create :device }
    before { visit device_models_path }
    it 'contains the current device types' do
      expect(page).to have_content(device.device_model.name)
      expect(page).to have_content(device.device_model.device_manufacturer.name)
    end

    it 'contains a link to device_types#new' do
      expect(page).to have_content('New')
    end
  end
end

