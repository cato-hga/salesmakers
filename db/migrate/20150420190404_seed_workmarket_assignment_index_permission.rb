class SeedWorkmarketAssignmentIndexPermission < ActiveRecord::Migration
  def self.up
    pg = PermissionGroup.create name: 'Workmarket'
    Permission.create key: 'workmarket_assignment_index',
                      description: 'view list of assignments',
                      permission_group: pg
    Permission.create key: 'workmarket_assignment_view_all',
                      description: 'view all data attached to an assignment',
                      permission_group: pg
  end

  def self.down
    Permission.where(key: 'workmarket_assignment_view_all').destroy_all
    Permission.where(key: 'workmarket_assignment_index').destroy_all
    PermissionGroup.where(name: 'Workmarket').destroy_all
  end
end
