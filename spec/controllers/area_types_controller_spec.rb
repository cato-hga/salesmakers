require 'rails_helper'

describe AreaTypesController do

  describe 'GET index' do
    let!(:project) { create :project }

    it 'returns a success status' do
      get :index, { client_id: project.client.id, project_id: project.id }
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

end