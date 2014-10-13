require 'rails_helper'

describe AreasController do
  let(:project) { Project.first }
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

    it 'should return a success status' do
      get :show, hash.merge(id: area.id)
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end

  describe 'GET sales'

end