require 'rails_helper'

RSpec.describe TrainingClassTypesController, :type => :controller do
  let(:trainer) { create :person, position: position }
  let(:position) { create :position, name: 'Trainer', permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'training_class_type_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'training_class_type_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let(:project) { create :project }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(trainer.email)
  end

  describe 'GET new' do
    it 'returns a success status' do
      get :new
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:class_type) { build :training_class_type }
    context 'failure' do
      before(:each) do
        post :create,
             training_class_type: {
                 name: 'Test'
             }
      end

      it 'does not create a new class type' do
        expect(TrainingClassType.all.count).to eq(0)
      end
      it 'renders the new template' do
        expect(response).to render_template :new
      end
    end
    context 'success' do
      before(:each) do
        post :create,
             training_class_type: {
                 name: 'Test',
                 project_id: project.id,
                 max_attendence: 25
             }
      end

      it 'creates a new class type' do
        expect(TrainingClassType.all.count).to eq(1)
      end
      it 'redirects to index' do
        expect(response).to redirect_to training_class_types_path
      end
      it 'creates a log entry' do
        expect(LogEntry.all.count).to eq(1)
      end
    end
  end
end