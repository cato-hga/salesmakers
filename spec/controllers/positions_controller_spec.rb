require 'rails_helper'

describe PositionsController do
  let(:department) { create :department }

  describe 'GET index' do
    it 'returns a success status' do
      allow(controller).to receive(:policy).and_return double(index?: true)
      get :index,
          department_id: department.id
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end
end