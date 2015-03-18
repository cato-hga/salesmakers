class SeedCandidatePermissionsToNonRecruiters < ActiveRecord::Migration
  def self.up
    permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    permission_index = Permission.find_or_create_by key: 'candidate_index',
                                                    description: "Can view candidates",
                                                    permission_group: permission_group
    permission_create = Permission.find_or_create_by key: 'candidate_create',
                                                     description: "Can view candidates",
                                                     permission_group: permission_group
    for position in get_positions do
      position.permissions << permission_index
      position.permissions << permission_create
    end
  end

  def self.down
    permission_index = Permission.find_or_create_by key: 'candidate_index',
                                                    description: "Can view candidates",
                                                    permission_group: permission_group
    permission_create = Permission.find_or_create_by key: 'candidate_create',
                                                     description: "Can view candidates",
                                                     permission_group: permission_group
    for position in get_positions do
      position.permissions.delete permission_index
      position.permissions.delete permission_create
    end
  end

  def get_positions
    pos_admin = Position.find_by_name 'System Administrator'
    pos_td = Position.find_by_name 'Training Director'
    pos_advd = Position.find_by_name 'Advocate Director'
    pos_advs = Position.find_by_name 'Advocate Supervisor'

    pos_ssd = Position.find_by_name 'Senior Software Developer'
    pos_sd = Position.find_by_name 'Software Developer'
    pos_itd = Position.find_by_name 'Information Technology Director'
    pos_itst = Position.find_by_name 'Information Technology Support Technician'

    pos_od = Position.find_by_name 'Operations Director'
    pos_oc = Position.find_by_name 'Operations Coordinator'
    pos_rc = Position.find_by_name 'Reporting Coordinator'

    pos_fa = Position.find_by_name 'Finance Administrator'

    pos_md = Position.find_by_name 'Marketing Director'

    pos_qad = Position.find_by_name 'Quality Assurance Director'
    pos_qaa = Position.find_by_name 'Quality Assurance Administrator'

    pos_ceo = Position.find_by_name 'Chief Executive Officer'
    pos_coo = Position.find_by_name 'Chief Operations Officer'
    pos_cfo = Position.find_by_name 'Chief Financial Officer'
    pos_vps = Position.find_by_name 'Vice President of Sales'
    pos_ea = Position.find_by_name 'Executive Assistant'

    pos_pd = Position.find_by_name 'Payroll Director'
    pos_pa = Position.find_by_name 'Payroll Administrator'

    pos_hras = Position.find_by_name 'Human Resources Director'
    pos_hra = Position.find_by_name 'Human Resources Administrator'

    [
        pos_admin,
        pos_td,
        pos_advd,
        pos_advs,
        pos_ssd,
        pos_sd,
        pos_itd,
        pos_itst,
        pos_od,
        pos_oc,
        pos_rc,
        pos_fa,
        pos_md,
        pos_qad,
        pos_qaa,
        pos_ceo,
        pos_coo,
        pos_cfo,
        pos_vps,
        pos_ea,
        pos_pd,
        pos_pa,
        pos_hras,
        pos_hra
    ].compact
  end
end
