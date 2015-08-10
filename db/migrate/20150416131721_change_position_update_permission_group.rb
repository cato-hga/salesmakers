class ChangePositionUpdatePermissionGroup < ActiveRecord::Migration
  def self.up
    from_pg = PermissionGroup.find_by name: 'Positions'
    to_pg = PermissionGroup.find_by name: 'Departments and Positions'
    permission = Permission.find_by key: 'position_update'
    permission.update permission_group: to_pg
    from_pg.destroy
  end
end
