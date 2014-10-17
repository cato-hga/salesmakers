require 'rails_helper'

describe ProjectsController do
  let(:project) { create :project }

  describe 'GET show' do
    it 'returns a success status' do
      get :show,
          client_id: project.client.id,
          id: project.id
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end

  describe 'GET sales' do
    it 'returns a success status' do
      get :sales,
          client_id: project.client.id,
          id: project.id
      expect(response).to be_success
      expect(response).to render_template(:sales)
    end
  end

end