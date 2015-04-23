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

  describe 'GET edit_permissions' do
    let(:position) { create :position }

    before do
      allow(controller).to receive(:policy).and_return double(edit_permissions?: true)
      get :edit_permissions,
          department_id: department.id,
          id: position.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the edit_permissions template' do
      expect(response).to render_template(:edit_permissions)
    end
  end

  describe 'PUT update_permissions' do
    let(:permission) { create :permission }
    let!(:it_tech) { create :it_tech_person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
      allow(controller).to receive(:policy).and_return double(update_permissions?: true)
    end

    context 'adding a permission' do
      let(:position) { create :position }
      let(:person) { create :person }

      subject do
        put :update_permissions,
            department_id: department.id,
            id: position.id,
            permissions: [permission.id.to_s]
      end

      it 'redirects to edit_permissions' do
        subject
        expect(response).to redirect_to(edit_permissions_department_position_path(position.department, position))
      end

      it 'updates the permissions' do
        expect {
          subject
        }.to change(position.permissions, :count).by(1)
      end

      it 'creates a log entry' do
        expect {
          subject
        }.to change(LogEntry, :count).by(1)
      end
    end

    context 'removing a permission' do
      let(:position) { create :position, permissions: [permission] }
      subject do
        put :update_permissions,
            department_id: department.id,
            id: position.id,
            permissions: []
      end

      it 'redirects to edit_permissions' do
        subject
        expect(response).to redirect_to(edit_permissions_department_position_path(position.department, position))
      end

      it 'updates the permissions' do
        expect {
          subject
          position.reload
        }.to change(position.permissions, :count).by(-1)
      end
    end
  end
end