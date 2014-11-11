require 'rails_helper'
require 'pundit/rspec'

describe ProjectsController do
  let(:project) { create :project }
  let(:project_without_wall) { create :project, wall: nil }

  describe 'GET show' do
    context 'success' do
      it 'returns a success status' do
        get :show,
            client_id: project.client.id,
            id: project.id
        expect(response).to be_success
        expect(response).to render_template(:show)
      end
    end

    context 'failure (no wall)' do
      subject { get :show,
                    client_id: project_without_wall.client.id,
                    id: project_without_wall.id
                   }
      it 'should return an error and redirect to :back'
    end
  end

  describe 'GET sales' do
    context 'success' do
      it 'returns a success status' do
        get :sales,
            client_id: project.client.id,
            id: project.id
        expect(response).to be_success
        expect(response).to render_template(:sales)
      end
    end

    context 'failure' do
      it 'should return an error and redirect to :back'
    end
  end
end