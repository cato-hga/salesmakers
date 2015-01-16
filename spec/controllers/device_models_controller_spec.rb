require 'rails_helper'

describe DeviceModelsController do

  describe 'GET index' do
    before(:each) do
      get :index
    end
    it 'returns a success status' do
      expect(response).to be_success
    end
    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

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
    let!(:manufacturer) { create :device_manufacturer }
    subject do
      post :create,
           device_model: {
               name: 'Test Model',
               device_manufacturer_id: manufacturer.id
           }
    end

    it 'creates a new model' do
      expect { subject }.to change(DeviceModel, :count).by(1)
    end
    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end
    it 'redirects to the index path' do
      subject
      expect(response).to redirect_to(device_models_path)
    end
    it 'assigns the new model to the correct manufacturer' do
      subject
      model = DeviceModel.first
      expect(model.device_manufacturer).to eq(manufacturer)
    end
  end
end