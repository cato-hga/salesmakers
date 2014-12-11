require 'rails_helper'

describe AreasController do
  let(:project) { create :project }
  let(:hash) { { project_id: project.id, client_id: project.client.id } }

  describe 'GET index' do
    it 'should return a success status' do
      get :index, hash
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    let(:area) { create :area, project: project }
    let(:area_hash) { hash.merge(id: area.id) }

    it 'should return a success status' do
      get :show, area_hash
      expect(response).to be_success
      expect(response).to render_template(:show)
    end

    it 'is passing the right area to the view' do
      get :show, area_hash
      expect(assigns(:area)).to eq(area)
    end
  end

  describe 'GET sales'

end