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

  describe 'GET new' do
    before { get :new }

    it 'should return a success status' do
      expect(response).to be_success
    end

    it 'should render the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do

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

    subject { get :write_off, id: device.id }

    it 'should render the show template' do
      expect(subject.request).to redirect_to(device)
    end

    it 'should assign the "Written Off" device status' do
      subject
      expect(device.device_states).to include(written_off)
    end

    it 'should flash a confirmation message' do
      expect(subject.request.flash[:notice]).to eq('Device Written Off!')
    end

    it 'should create a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end
  end
end