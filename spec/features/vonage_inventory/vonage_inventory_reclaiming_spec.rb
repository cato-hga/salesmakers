require 'rails_helper'

let(:person) { create :person, position: position}
let(:position) {create :position, permissions: [permission_create] }
let(:permission_group) { PermissionGroup.new name: 'Test Permission Group'}
let(:permission_create) { Permission.new key: 'vonage_inventory_receive_create',
                                         permission_group: permission_group,
                                         description: 'Test Description' }
