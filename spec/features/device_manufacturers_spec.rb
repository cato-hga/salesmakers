require 'rails_helper'

feature "DeviceManufacturers", :type => :feature do

  describe 'GET new' do
    it 'has a form for adding new model' do
      visit new_device_manufacturer_path
      expect(page).to have_content('New Device Manufacturer')
      expect(page).to have_button('Submit')
    end
  end
end
