require 'rails_helper'

describe 'Inventory Reclaim page' do
  let(:person1) { create :person, display_name: 'person1'}
  let(:person2) { create :person, display_name: 'person2'}
  let(:person3) { create :person, display_name: 'person3'}
  let(:person4) { create :person, display_name: 'person4'}
  let(:person5) { create :person, display_name: 'person5'}
  let(:manager) { create :person, position: position, display_name: 'manager'}

  let(:position) { create :position, permissions: [permission_create, permission_reclaim] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'vonage_device_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_reclaim) { Permission.new key: 'vonage_device_reclaim',
                                           permission_group: permission_group,
                                           description: 'Test Description' }



end
