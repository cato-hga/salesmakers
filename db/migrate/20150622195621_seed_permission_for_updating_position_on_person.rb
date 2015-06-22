class SeedPermissionForUpdatingPositionOnPerson < ActiveRecord::Migration
  def up
    group = PermissionGroup.find_by name: 'People'
    Permission.create permission_group: group,
                      description: 'edit positions for a person',
                      key: 'person_update_position'
  end

  def down
    Permission.where(key: 'person_update_position').destroy_all
  end
end
