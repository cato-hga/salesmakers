class SeedWorkmarketAssignmentShowPermission < ActiveRecord::Migration
  def self.up
    pg = PermissionGroup.find_by name: 'Workmarket' || return
    pg.permissions.create key: 'workmarket_assignment_show',
                          description: "view a workmarket assignment's details",
                          permission_group: pg
  end

  def self.down
    Permission.where(key: 'workmarket_assignment_show').destroy_all
  end
end
