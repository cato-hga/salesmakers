require 'rails_helper'

feature "DeviceManufacturers", :type => :feature do

  describe 'GET new' do
    it 'has a form for adding new model' do
      visit new_device_manufacturer_path
      expect(page).to have_content('New Device Manufacturer')
      expect(page).to have_button('Submit')
    end
  end

  describe 'POST create' do
    before(:each) do
      visit new_device_manufacturer_path
      fill_in 'device_manufacturer_name', with: 'Test Manufacturer'
      click_on 'Submit'
    end

    it 'creates a new device model' do
      expect(page).to have_content('Test Manufacturer')
    end

    it 'flashes a success message' do
      expect(page).to have_content('Device manufacturer created')
    end

    it 'redirects to the new device model path' do
      expect(page).to have_content('New Device Model')
    end
  end
end
