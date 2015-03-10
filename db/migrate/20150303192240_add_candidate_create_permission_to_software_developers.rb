class AddCandidateCreatePermissionToSoftwareDevelopers < ActiveRecord::Migration
  def up
    pos_ssd = Position.find_by name: 'Senior Software Developer'
    pos_sd = Position.find_by name: 'Software Developer'
    developer_positions = [pos_ssd, pos_sd]

    candidate_permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    candidate_create = Permission.find_or_create_by key: 'candidate_create',
                                                    description: 'can create Candidates',
                                                    permission_group: candidate_permission_group

    for position in developer_positions do
      position.permissions << candidate_create
    end
  end

  def down
    pos_ssd = Position.find_by name: 'Senior Software Developer'
    pos_sd = Position.find_by name: 'Software Developer'
    developer_positions = [pos_ssd, pos_sd]

    candidate_permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    candidate_create = Permission.find_or_create_by key: 'candidate_create',
                                                    description: 'can create Candidates',
                                                    permission_group: candidate_permission_group

    for position in developer_positions do
      position.permissions.delete candidate_create
    end
  end
end
