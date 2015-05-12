class AddCandidateDashboardPermission < ActiveRecord::Migration
  def self.up
    permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    permission_dashboard = Permission.find_or_create_by key: 'candidate_dashboard',
                                                        description: "Can view candidate dashboard",
                                                        permission_group: permission_group


    ops = Position.find_by_name 'Operations Coordinator'
    adv = Position.find_by_name 'Advocate Supervisor'

    ops.permissions << permission_dashboard
    adv.permissions << permission_dashboard
  end

  def self.down

    permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    permission_dashboard = Permission.find_or_create_by key: 'candidate_dashboard',
                                                        description: "Can view candidate dashboard",
                                                        permission_group: permission_group

    ops = Position.find_by_name 'Operations Coordinator'
    adv = Position.find_by_name 'Advocate Supervisor'

    ops.permissions.delete permission_dashboard
    adv.permissions.delete permission_dashboard
  end
end
