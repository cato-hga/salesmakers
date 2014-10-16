require 'rails_helper'

describe PositionsController do
  let(:department) { Department.first }

  describe 'GET index' do
    it 'returns a success status' do
      get :index,
          department_id: department.id
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end
end