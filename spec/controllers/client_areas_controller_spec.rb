require 'rails_helper'

describe ClientAreasController do
  let(:project) { create :project }
  let(:hash) { { project_id: project.id, client_id: project.client.id } }

  describe 'GET index' do
    it 'should return a success status' do
      allow(controller).to receive(:policy).and_return double(index?: true)
      get :index, hash
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end
end