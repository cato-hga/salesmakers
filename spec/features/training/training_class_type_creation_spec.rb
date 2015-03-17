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
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      visit new_training_class_type_path
    end
  end
end
