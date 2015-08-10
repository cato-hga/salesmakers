require 'rails_helper'

describe AreaTypesController do
  let(:project) { create :project }

  describe 'GET index' do
    it 'returns a success status' do
      allow(controller).to receive(:policy).and_return double(index?: true)
      get :index, { client_id: project.client.id, project_id: project.id }
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end
end