class AddVonageReclaimingPermission < ActiveRecord::Migration
  def change
    group = PermissionGroup.find_or_create_by name: 'Vonage'
    permission = Permission.find_or_create_by key: 'vonage_device_reclaim',
                                              permission_group: group,
                                              description: 'Ability to reclaim vonage devices.'

    vesm = Position.find_by name: "Vonage Event Area Sales Manager"
    velit = Position.find_by name: "Vonage Event Leader in Training"
    verm = Position.find_by name: "Vonage Event Regional Manager"
    vetl = Position.find_by name: "Vonage Event Team Leader"

    vesm.permissions << permission
    velit.permissions << permission
    verm.permissions << permission
    vetl.permissions << permission
  end
end
