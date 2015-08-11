  class AddVonageDeviceCreate < ActiveRecord::Migration
    def change
      group = PermissionGroup.find_or_create_by name: 'Vonage'
      permission = Permission.find_or_create_by key: 'vonage_device_create',
                                     permission_group: group,
                                     description: 'can receive vonage inventory'

      vesm = Position.find_by name: "Vonage Event Area Sales Manager"
      velit = Position.find_by name: "Vonage Event Leader in Training"
      verm = Position.find_by name: "Vonage Event Regional Manager"
      vess = Position.find_by name: "Vonage Event Sales Specialist"
      vetl = Position.find_by name: "Vonage Event Team Leader"


      vesm.permissions << permission
      velit.permissions << permission
      verm.permissions << permission
      vess.permissions << permission
      vetl.permissions << permission

      receivings = Permission.find_by key: 'vonage_inventory_receivings'

      vesm.permissions.delete(receivings)
      velit.permissions.delete(receivings)
      verm.permissions.delete(receivings)
      vess.permissions.delete(receivings)
      vetl.permissions.delete(receivings)
    end
  end
