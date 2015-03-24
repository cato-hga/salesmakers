class AddCandidatePermissionsToPositions < ActiveRecord::Migration
  def up
    permission_group_outsourced = PermissionGroup.find_or_create_by name: 'Areas and Locations'
    permission_outsourced = Permission.find_or_create_by key: 'location_area_outsourced',
                                                         description: "Can view outsourced doors",
                                                         permission_group: permission_group_outsourced
    permission_outsourced.update permission_group: permission_group_outsourced

    permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    permission_index = Permission.find_or_create_by key: 'candidate_index',
                                                    description: "Can view candidates",
                                                    permission_group: permission_group
    permission_create = Permission.find_or_create_by key: 'candidate_create',
                                                     description: "Can view candidates",
                                                     permission_group: permission_group

    pos_vrrm = Position.find_by_name 'Vonage Retail Regional Manager'
    pos_vrasm = Position.find_by_name 'Vonage Retail Area Sales Manager'
    pos_ops = Position.find_by_name 'Operations Coordinator'
    pos_srsd = Position.find_by_name 'Sprint Retail Sales Director'
    pos_vrtm = Position.find_by_name 'Vonage Retail Territory Manager'
    pos_vetl = Position.find_by_name 'Vonage Event Team Leader'
    positions = [pos_vrrm, pos_vrasm, pos_ops, pos_srsd, pos_vrtm, pos_vetl]

    for position in positions do
      position.permissions << permission_index
      position.permissions << permission_create
    end

  end

  def down
    permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    permission_index = Permission.find_or_create_by key: 'candidate_index',
                                                    description: "Can view candidates",
                                                    permission_group: permission_group
    permission_create = Permission.find_or_create_by key: 'candidate_create',
                                                     description: "Can view candidates",
                                                     permission_group: permission_group

    pos_vrrm = Position.find_by_name 'Vonage Retail Regional Manager'
    pos_vrasm = Position.find_by_name 'Vonage Retail Area Sales Manager'
    pos_ops = Position.find_by_name 'Operations Coordinator'
    pos_srsd = Position.find_by_name 'Sprint Retail Sales Director'
    pos_vrtm = Position.find_by_name 'Vonage Retail Territory Manager'
    pos_vetl = Position.find_by_name 'Vonage Event Team Leader'
    positions = [pos_vrrm, pos_vrasm, pos_ops, pos_srsd, pos_vrtm, pos_vetl]

    for position in positions do
      position.permissions.delete permission_index
      position.permissions.delete permission_create
    end
  end
end
