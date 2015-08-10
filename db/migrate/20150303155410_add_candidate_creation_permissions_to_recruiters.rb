class AddCandidateCreationPermissionsToRecruiters < ActiveRecord::Migration
  def up
    pos_adv_dir = Position.find_by name: 'Advocate Director'
    pos_adv_super = Position.find_by name: 'Advocate Supervisor'
    pos_adv = Position.find_by name: 'Advocate'
    pos_recruiting_dir = Position.find_by name: 'Recruiting Call Center Director'
    pos_recruiting_rep = Position.find_by name: 'Recruiting Call Center Representative'
    recruiting_positions = [pos_adv_dir, pos_adv_super, pos_adv, pos_recruiting_dir, pos_recruiting_rep]

    candidate_permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    candidate_create = Permission.find_or_create_by key: 'candidate_create',
                                                    description: 'can create Candidates',
                                                    permission_group: candidate_permission_group

    for position in recruiting_positions do
      position.permissions << candidate_create
    end
  end

  def down
    pos_adv_dir = Position.find_by name: 'Advocate Director'
    pos_adv_super = Position.find_by name: 'Advocate Supervisor'
    pos_adv = Position.find_by name: 'Advocate'
    pos_recruiting_dir = Position.find_by name: 'Recruiting Call Center Director'
    pos_recruiting_rep = Position.find_by name: 'Recruiting Call Center Representative'
    recruiting_positions = [pos_adv_dir, pos_adv_super, pos_adv, pos_recruiting_dir, pos_recruiting_rep]

    candidate_permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    candidate_create = Permission.find_or_create_by key: 'candidate_create',
                                                    description: 'can create Candidates',
                                                    permission_group: candidate_permission_group

    for position in recruiting_positions do
      position.permissions.delete candidate_create
    end
    candidate_create.destroy
    candidate_permission_group.destroy
  end
end
