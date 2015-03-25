class AddCandidatePermissionsToElizabet < ActiveRecord::Migration
  def self.up
    permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    permission_index = Permission.find_or_create_by key: 'candidate_index',
                                                    description: "Can view candidates",
                                                    permission_group: permission_group
    permission_create = Permission.find_or_create_by key: 'candidate_create',
                                                     description: "Can view candidates",
                                                     permission_group: permission_group

    finance = Position.find_by_name 'Finance Administrator'

    finance.permissions << permission_index
    finance.permissions << permission_create

  end

  def self.up
    permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    permission_index = Permission.find_or_create_by key: 'candidate_index',
                                                    description: "Can view candidates",
                                                    permission_group: permission_group
    permission_create = Permission.find_or_create_by key: 'candidate_create',
                                                     description: "Can view candidates",
                                                     permission_group: permission_group

    finance = Position.find_by_name 'Finance Administrator'
    finance.permissions.delete permission_index
    finance.permissions.delete permission_create

  end
end
