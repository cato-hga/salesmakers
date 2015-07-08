class SeedClientAreaPermissions < ActiveRecord::Migration
  def up
    permission_group = PermissionGroup.find_or_create_by name: 'Areas and Locations'
    Permission.create key: 'client_area_index', permission_group: permission_group, description: 'view list of client areas'
  end

  def down
    Permission.where(key: 'client_area_index').destroy_all
  end
end
