require 'rails_helper'
describe 'Training class type creation' do

  let(:trainer) { create :person, position: position }
  let(:position) { create :position, name: 'Trainer', permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'training_class_type_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'training_class_type_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let!(:project) { create :project }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(trainer.email)
  end

  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_training_class_type_path
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(trainer.email)
      visit new_training_class_type_path
    end

    describe 'new form' do
      it 'has all fields' do
        expect(page).to have_content 'Name of training type'
        expect(page).to have_content 'Project for class type'
        expect(page).to have_content 'Max Attendence in class'
        expect(page).to have_button 'Save'
      end
    end

    describe 'form submission' do
      context 'with invalid data' do
        it 'shows all relevant error messages' do
          click_on 'Save'
          expect(page).to have_content 'Training Class Type could not be saved'
          expect(page).to have_content "Name can't be blank"
          expect(page).to have_content "Project can't be blank"
        end
      end
      context 'with valid data' do
        before(:each) do
          fill_in 'Name', with: 'Test'
          select project.name, from: 'Project'
          click_on 'Save'
        end
        it 'displays a flash message' do
          expect(page).to have_content 'Training Class Type saved!'
        end
        it 'redirects to the training type index page' do
          expect(page).to have_content 'Training Class Types'
          type = TrainingClassType.first
          expect(page).to have_content type.name
        end
      end
    end
  end
end
