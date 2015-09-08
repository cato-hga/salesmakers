class SeedAreaManagementScorecardPermission < ActiveRecord::Migration
  def up
    permission_group = PermissionGroup.find_or_create_by name: 'Areas and Locations'
    permission_group.permissions.create key: 'area_management_scorecard', description: 'view scorecards for areas'
  end

  def down
    Permission.where(key: 'area_management_scorecard').destroy_all
  end
end
