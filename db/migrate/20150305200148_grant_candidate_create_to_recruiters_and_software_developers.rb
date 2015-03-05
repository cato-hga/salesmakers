class GrantCandidateCreateToRecruitersAndSoftwareDevelopers < ActiveRecord::Migration
  def up
    pos_adv_dir = Position.find_by name: 'Advocate Director'
    pos_adv_super = Position.find_by name: 'Advocate Supervisor'
    pos_adv = Position.find_by name: 'Advocate'
    pos_recruiting_dir = Position.find_by name: 'Recruiting Call Center Director'
    pos_recruiting_rep = Position.find_by name: 'Recruiting Call Center Representative'
    pos_ssd = Position.find_by name: 'Senior Software Developer'
    pos_sd = Position.find_by name: 'Software Developer'
    positions = [pos_adv_dir, pos_adv_super, pos_adv, pos_recruiting_dir, pos_recruiting_rep, pos_ssd, pos_sd]

    candidate_permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    candidate_index = Permission.find_or_create_by key: 'candidate_index',
                                                   description: 'can view index of Candidates',
                                                   permission_group: candidate_permission_group

    for position in positions do
      position.permissions << candidate_index
    end
  end

  def down
    pos_adv_dir = Position.find_by name: 'Advocate Director'
    pos_adv_super = Position.find_by name: 'Advocate Supervisor'
    pos_adv = Position.find_by name: 'Advocate'
    pos_recruiting_dir = Position.find_by name: 'Recruiting Call Center Director'
    pos_recruiting_rep = Position.find_by name: 'Recruiting Call Center Representative'
    pos_ssd = Position.find_by name: 'Senior Software Developer'
    pos_sd = Position.find_by name: 'Software Developer'
    positions = [pos_adv_dir, pos_adv_super, pos_adv, pos_recruiting_dir, pos_recruiting_rep, pos_ssd, pos_sd]

    candidate_permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    candidate_index = Permission.find_or_create_by key: 'candidate_index',
                                                   description: 'can view index of Candidates',
                                                   permission_group: candidate_permission_group

    for position in positions do
      position.permissions.delete candidate_index
    end
    candidate_index.destroy
  end
end
