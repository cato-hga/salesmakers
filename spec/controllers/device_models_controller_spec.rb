require 'rails_helper'

describe DeviceModelsController do
  let!(:person) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

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
      allow(controller).to receive(:policy).and_return double(new?: true)
      get :new
    end
    it 'returns a success status' do
      expect(response).to be_success
    end
    it 'renders the new template' do
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

  describe 'GET edit' do
    let(:device_model) { create :device_model }
    before(:each) do
      get :edit,
          id: device_model.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end
    it 'renders the edit template' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH update success' do
    let(:device_model) { create :device_model }
    subject do
      patch :update,
            id: device_model.id,
            device_model: {
                name: 'New Model Name'
            }
    end

    it 'changes the model name' do
      subject
      device_model.reload
      expect(device_model.name).to eq('New Model Name')
    end

    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end

    it 'redirects to the index path' do
      subject
      expect(response).to redirect_to(device_models_path)
    end
  end

  describe 'PATCH update failure' do
    let(:device_model) { create :device_model }
    subject do
      patch :update,
            id: device_model.id,
            device_model: {
                name: 'No'
            }
    end

    it 'does not change the model name' do
      subject
      expect(device_model.name).not_to eq('No')
    end

    it 'renders the edit template' do
      subject
      expect(response).to render_template(:edit)
    end
  end
end