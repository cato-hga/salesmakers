class SeedCandidateSelectLocationPermissions < ActiveRecord::Migration
  def up
    permission_group = PermissionGroup.find_by name: 'Candidates'
    permission = Permission.create permission_group: permission_group,
                                   key: 'candidate_select_location',
                                   description: 'select a location for candidates'
    create_permission = Permission.find_by key: 'candidate_create'
    return if create_permission.nil?
    for position in create_permission.positions do
      position.permissions << permission
    end
  end

  def down
    permission = Permission.find_by key: 'candidate_select_location'
    for position in permission.positions do
      position.permissions.delete permission
    end
    permission.destroy
  end
end
