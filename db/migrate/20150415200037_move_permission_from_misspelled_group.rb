class MovePermissionFromMisspelledGroup < ActiveRecord::Migration
  def self.up
    permission_group = PermissionGroup.find_by name: 'Areas and Lcoations'
    to_permission_group = PermissionGroup.find_by name: 'Areas and Locations'
    for permission in permission_group.permissions do
      to_permission = Permission.find_by key: permission.key, permission_group: to_permission_group
      for position in permission.positions do
        next if to_permission.positions.include? position
        position.permissions << to_permission
        position.permissions.delete permission
      end
      permission.destroy
    end
    permission_group.destroy
  end
end
