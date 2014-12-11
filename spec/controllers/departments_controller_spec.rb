require 'rails_helper'

describe DepartmentsController do
  let(:department) { create :department }

  describe 'GET index' do
    it 'returns a success status' do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    it 'returns a success status' do
      get :show, id: department.id
      expect(response).to be_success
      expect(response).to render_template(:show)
    end

    it 'passes the correct department to the view' do
      get :show, id: department.id
      expect(assigns(:department)).to eq(department)
    end
  end
end