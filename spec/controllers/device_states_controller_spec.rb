require 'rails_helper'

describe DeviceStatesController do

  describe 'GET index' do
    before { get :index }
    it 'should return a success status' do
      expect(response).to be_success
    end
    it 'should render the index template' do
      expect(response).to render_template(:index)
    end
  end
end