class CreateCandidateVipPermission < ActiveRecord::Migration
  def change
    group = PermissionGroup.find_by name: 'Candidates'
    Permission.create key: 'candidate_vip',
                      permission_group: group,
                      description: 'can mark Candidates as VIPs'

    CandidateSource.create name: 'Project VIP', active: true
  end
end
