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

  describe 'GET new' do
    before { get :new }
    it 'should return a success status' do
      expect(response).to be_success
    end
    it 'should render the index template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'GET show' do
    let(:state) { DeviceState.first }
    before {
      get :show,
          id: state.id
    }
    it 'should return a success status' do
      expect(response).to be_success
    end
    it 'should render the index template' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET edit' do
    let(:state) { DeviceState.first }
    before {
      get :edit,
          id: state.id
    }
    it 'should return a success status' do
      expect(response).to be_success
    end
    it 'should render the index template' do
      expect(response).to render_template(:edit)
    end
  end
end