require 'rails_helper'

describe 'DeviceModels spec' do

  let!(:person) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'GET index' do
    let!(:device) { create :device }
    before(:each) do
      visit device_models_path
    end
    it 'contains the current device models' do
      expect(page).to have_content(device.device_model.name)
      expect(page).to have_content(device.device_model.device_manufacturer.name)
    end

    it 'contains a link to device_models#new' do
      expect(page).to have_content('New')
    end

    it 'contains a link to device_models#edit' do
      expect(page).to have_content('Edit')
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
      expect(page).to have_content('Model Name')
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

  describe 'edit' do
    let(:model) { create :device_model }

    it 'has a form to edit the device model' do
      visit edit_device_model_path model
      expect(page).to have_content('Edit')
      expect(page).to have_button('Submit')
      expect(page).to have_content('Model Name')
    end
  end

  describe 'model update success' do
    let(:model) { create :device_model }
    before(:each) do
      visit edit_device_model_path model
      fill_in 'device_model_name', with: 'New Model Name'
      click_on 'Submit'
    end

    it 'changes the model name' do
      expect(page).to have_content('New Model Name')
    end


    it 'redirects to the index path' do
      expect(page).to have_content('Device Models')
    end
  end

  describe 'model update failure' do
    let(:model) { create :device_model }
    before(:each) do
      visit edit_device_model_path model
      fill_in 'device_model_name', with: 'No'
      click_on 'Submit'
    end

    it 'renders the edit template' do
      expect(page).to have_content('Edit Device Model')
    end

    it 'displays error messages' do
      expect(page).to have_content('Name is too short')
    end
  end
end

