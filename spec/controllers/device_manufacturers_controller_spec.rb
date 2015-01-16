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
end
