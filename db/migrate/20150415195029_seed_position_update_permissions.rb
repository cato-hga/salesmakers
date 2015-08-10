class SeedPositionUpdatePermissions < ActiveRecord::Migration
  def self.up
    department = Department.find_by name: 'Information Technology'
    return unless department
    permission_group = PermissionGroup.find_or_create_by name: 'Positions'
    permission = Permission.find_or_create_by key: 'position_update',
                                              description: 'can edit positions and their permissions',
                                              permission_group: permission_group
    for position in department.positions do
      position.permissions << permission
    end
  end

  def self.down
    department = Department.find_by name: 'Information Technology'
    return unless department
    permission = Permission.find_or_create_by key: 'position_update',
                                              description: 'can edit positions and their permissions',
                                              permission_group: permission_group
    for position in department.positions do
      position.permissions.delete permission
    end
  end
end
