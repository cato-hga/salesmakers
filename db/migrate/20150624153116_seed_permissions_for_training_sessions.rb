class SeedPermissionsForTrainingSessions < ActiveRecord::Migration
  def up
    permission_group = PermissionGroup.find_by name: 'Sprint'
    return unless permission_group
    Permission.create key: 'sprint_radio_shack_training_session_create',
                      description: 'create RadioShack training sessions',
                      permission_group: permission_group
    Permission.create key: 'sprint_radio_shack_training_session_index',
                      description: 'view the list of RadioShack training sessions',
                      permission_group: permission_group
    Permission.create key: 'sprint_radio_shack_training_session_update',
                      description: 'edit existing RadioShack training sessions',
                      permission_group: permission_group
  end

  def down
    Permission.where(key: 'sprint_radio_shack_training_session_create').destroy_all
    Permission.where(key: 'sprint_radio_shack_training_session_index').destroy_all
    Permission.where(key: 'sprint_radio_shack_training_session_update').destroy_all
  end
end
