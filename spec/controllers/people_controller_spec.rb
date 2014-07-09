require 'rails_helper'

RSpec.describe PeopleController, :type => :controller do

  describe 'GET index' do


    it 'should return a 200 response' do
      get :index
      expect(response.status).to eq(200)
    end

    it 'should return the index' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do

    before(:all) do
      @sales_specialist_person = FactoryGirl.create :von_retail_sales_specialist_person
    end

    after(:all) do
      @sales_specialist_person.destroy
    end

    it 'should return a 200 response' do
      get :show, id: @sales_specialist_person.id
      expect(response.status).to eq(200)
    end

    it 'should return the index' do
      get :show, id: @sales_specialist_person.id
      expect(response).to render_template(:show)
    end

  end
end
