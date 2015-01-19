require 'rails_helper'

describe DeviceManufacturersController, :type => :controller do

  describe 'GET new' do
    before(:each) do
      get :new
    end
    it 'returns a success status' do
      expect(response).to be_success
    end
    it 'renders the index template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    subject do
      post :create,
           device_manufacturer: {
               name: 'Test Manufacturer'
           }
    end

    it 'creates a new model' do
      expect { subject }.to change(DeviceManufacturer, :count).by(1)
    end
    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end
    it 'redirects to the new_device_models path' do
      subject
      expect(response).to redirect_to(new_device_model_path)
    end
  end
end
