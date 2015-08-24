class CreateLocationUpdatePermissionAndSeed < ActiveRecord::Migration
  def up
    permission_group = PermissionGroup.find_by name: 'Locations' || return
    location_update = Permission.create key: 'location_update',
                                        description: 'can edit locations',
                                        permission_group: permission_group
    position = Position.find_by name: 'Senior Software Developer' || return
    position.permissions << location_update
    position = Position.find_by name: 'Software Developer' || return
    position.permissions << location_update
    position = Position.find_by name: 'Juan' || return
    position.permissions << location_update
  end

  def down
    location_update = Permission.find_by key: 'location_update' || return
    position = Position.find_by name: 'Senior Software Developer'
    position.permissions.delete location_update if position
    position = Position.find_by name: 'Software Developer'
    position.permissions.delete location_update if position
    position = Position.find_by name: 'Juan'
    position.permissions.delete location_update if position
    location_update.destroy
  end
end
