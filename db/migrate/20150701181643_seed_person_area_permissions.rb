class SeedPersonAreaPermissions < ActiveRecord::Migration
  def up
    pg = PermissionGroup.find_by name: 'People'
    Permission.create key: 'person_area_create', permission_group: pg, description: 'add new areas to a person'
    Permission.create key: 'person_area_update', permission_group: pg, description: 'edit existing areas for a person'
    Permission.create key: 'person_area_destroy', permission_group: pg, description: 'remove areas from a person'
  end

  def down
    Permission.where(key: 'person_area_create').destroy_all
    Permission.where(key: 'person_area_update').destroy_all
    Permission.where(key: 'person_area_destroy').destroy_all
  end
end
