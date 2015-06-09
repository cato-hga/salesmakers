class SeedReportQueryPermissions < ActiveRecord::Migration
  def self.up
    permission_group = PermissionGroup.create name: 'Report Queries'
    create_permission = Permission.create key: 'report_query_create',
                                          description: 'create report queries',
                                          permission_group: permission_group
    update_permission = Permission.create key: 'report_query_update',
                                          description: 'edit existing report queries',
                                          permission_group: permission_group
    destroy_permission = Permission.create key: 'report_query_destroy',
                                           description: 'delete existing report queries',
                                           permission_group: permission_group
    for position in get_positions do
      position.permissions << create_permission
      position.permissions << update_permission
      position.permissions << destroy_permission
    end

  end

  def self.down
    create_permission = Permission.find_by key: 'report_query_create'
    update_permission = Permission.find_by key: 'report_query_update'
    destroy_permission = Permission.find_by key: 'report_query_destroy'
    for position in get_positions do
      position.permissions.delete create_permission if create_permission
      position.permissions.delete update_permission if update_permission
      position.permissions.delete destroy_permission if destroy_permission
    end
    create_permission.destroy if create_permission
    update_permission.destroy if update_permission
    destroy_permission.destroy if destroy_permission
    permission_group = PermissionGroup.find_by name: 'Report Queries'
    permission_group.destroy if permission_group
  end

  private

  def get_positions
    positions = []
    positions << Position.find_by(name: 'Senior Software Developer')
    positions << Position.find_by(name: 'Software Developer')
    positions << Position.find_by(name: 'System Administrator')
    positions << Position.find_by(name: 'Reporting Coordinator')
    positions
  end
end
