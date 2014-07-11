require 'rails_helper'

RSpec.describe ClientsController, :type => :controller do

  it 'should return a 200 response' do
    get :index
    expect(response.status).to eq(200)
  end

  it 'should return the index' do
    get :index
    expect(response).to render_template(:index)
  end


  describe 'GET show' do

    before(:all) do
      @clients = FactoryGirl.create :von_client
    end

    after(:all) do
      @clients.destroy
    end

    it 'should return a 200 response' do
      get :show, id: @clients.id
      expect(response.status).to eq(200)
    end

    it 'should return the index' do
      get :show, id: @clients.id
      expect(response).to render_template(:show)
    end
  end
end
