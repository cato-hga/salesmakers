require 'rails_helper'

describe ClientsController do
  let(:client) { create :client }

  describe 'GET index' do
    before(:each) do
      allow(controller).to receive(:policy).and_return double(index?: true)
    end
    it 'returns a success status' do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do

    it 'returns a success status' do
      get :show, id: client.id
      expect(response).to be_success
      expect(response).to render_template(:show)
    end

    it 'passes the correct client to the view' do
      get :show, id: client.id
      expect(assigns(:client)).to eq(client)
    end
  end
end