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
end