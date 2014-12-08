require 'rails_helper'

describe DevicesController do

  describe 'GET index' do
    before { get :index }

    it 'should return a success status' do
      expect(response).to be_success
    end

    it 'should render the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    let(:device) { create :device }

    before {
      get :show,
          id: device.id
    }
    it 'should return a success status' do
      expect(response).to be_success
    end

    it 'should render the show template' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET write_off' do
    let(:device) { create :device }
    let(:written_off) { DeviceState.find_by name: 'Written Off' }

    before { get :write_off, id: device.id }

    it 'should render the show template' do
      expect(response).to redirect_to(device)
    end

    it 'should assign the "Written Off" device status' do
      expect(device.device_states).to include(written_off)
    end
  end
end