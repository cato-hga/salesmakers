require 'rails_helper'

describe 'DeviceModels spec' do

  describe 'GET index' do
    let!(:device) { create :device }
    before(:each) do
      visit device_models_path
    end
    it 'contains the current device types' do
      expect(page).to have_content(device.device_model.name)
      expect(page).to have_content(device.device_model.device_manufacturer.name)
    end

    it 'contains a link to device_types#new' do
      expect(page).to have_content('New')
    end
  end

  describe 'new' do
    let!(:device) { create :device }
    before(:each) do
      visit new_device_model_path
    end

    it 'contains dropdowns for the current manufacturers' do
      expect(page).to have_content(device.device_model.device_manufacturer.name)
    end
    it 'contains an option to create a new manufacturer' do
      expect(page).to have_content('New Manufacturer')
    end
    it 'contains the option to enter a new device model' do
      expect(page).to have_content('New Model')
    end
  end

  describe 'create success' do
    let!(:manufacturer) { create :device_manufacturer }
    before(:each) do
      visit new_device_model_path
      select manufacturer.name, from: 'device_model_device_manufacturer_id'
      fill_in 'device_model_name', with: 'Test Model'
      click_on 'Submit'
    end

    it 'creates a new device model' do
      expect(page).to have_content('Test Model')
    end

    it 'flashes a success message' do
      expect(page).to have_content('Device model created')
    end
  end

  describe 'create failure' do
    let!(:manufacturer) { create :device_manufacturer }
    before(:each) do
      visit new_device_model_path
      select manufacturer.name, from: 'device_model_device_manufacturer_id'
      fill_in 'device_model_name', with: ''
      click_on 'Submit'
    end

    it 'renders the new template' do
      expect(page).to have_content('New Device Model')
    end

    it 'displays error messages' do
      expect(page).to have_content("Name can't be blank")
    end
  end
end

