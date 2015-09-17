class SeedGroupMeGroupPostPermissions < ActiveRecord::Migration
  def self.up
    permission = get_permission
    for position in get_positions do
      next if position.permissions.include?(permission)
      position.permissions << permission
    end
  end

  def self.down
    permission = get_permission
    for position in get_positions do
      position.permissions.delete(permission)
    end
  end

  private

  def get_permission
    permission_group = PermissionGroup.find_or_create_by name: 'GroupMe'
    Permission.find_or_create_by key: 'group_me_group_post',
                                 description: 'can post to GroupMe groups via bot',
                                 permission_group: permission_group

  end

  def get_positions
    pos_admin = Position.find_by_name 'System Administrator'
    pos_vrrvp = Position.find_by_name 'Vonage Regional Vice President'
    pos_vrrm = Position.find_by_name 'Vonage Regional Manager'
    pos_vrasm = Position.find_by_name 'Vonage Area Sales Manager'
    pos_vrtm = Position.find_by_name 'Vonage Territory Manager'

    pos_vervp = Position.find_by_name 'Vonage Event Regional Vice President'
    pos_verm = Position.find_by_name 'Vonage Event Regional Manager'
    pos_veasm = Position.find_by_name 'Vonage Event Area Sales Manager'
    pos_vetl = Position.find_by_name 'Vonage Event Team Leader'
    pos_velit = Position.find_by_name 'Vonage Event Leader in Training'

    pos_srrvp = Position.find_by_name 'Sprint Retail Regional Vice President'
    pos_srrm = Position.find_by_name 'Sprint Retail Regional Manager'
    pos_srasm = Position.find_by_name 'Sprint Retail Area Sales Manager'
    pos_srtm = Position.find_by_name 'Sprint Retail Sales Director'

    pos_ccrrvp = Position.find_by name: 'Comcast Retail Regional Vice President'
    pos_ccrtm = Position.find_by name: 'Comcast Retail Territory Manager'

    pos_uc = Position.find_by_name 'Unclassified HQ Employee'

    pos_td = Position.find_by_name 'Training Director'
    pos_t = Position.find_by_name 'Trainer'

    pos_advd = Position.find_by_name 'Advocate Director'
    pos_advs = Position.find_by_name 'Advocate Supervisor'
    pos_adv = Position.find_by_name 'Advocate'
    pos_rccd = Position.find_by_name 'Recruiting Call Center Director'
    pos_rccr = Position.find_by_name 'Recruiting Call Center Representative'

    pos_ssd = Position.find_by_name 'Senior Software Developer'
    pos_sd = Position.find_by_name 'Software Developer'
    pos_itd = Position.find_by_name 'Information Technology Director'
    pos_itst = Position.find_by_name 'Information Technology Support Technician'

    pos_od = Position.find_by_name 'Operations Director'
    pos_oc = Position.find_by_name 'Operations Coordinator'
    pos_ic = Position.find_by_name 'Inventory Coordinator'
    pos_rc = Position.find_by_name 'Reporting Coordinator'

    pos_fa = Position.find_by_name 'Finance Administrator'
    pos_cont = Position.find_by_name 'Controller'
    pos_acc = Position.find_by_name 'Accountant'

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
        pos_vrrvp,
        pos_vrrm,
        pos_vrasm,
        pos_vrtm,
        pos_vervp,
        pos_verm,
        pos_veasm,
        pos_vetl,
        pos_velit,
        pos_srrvp,
        pos_srrm,
        pos_srasm,
        pos_srtm,
        pos_ccrrvp,
        pos_ccrtm,
        pos_uc,
        pos_td,
        pos_t,
        pos_advd,
        pos_advs,
        pos_adv,
        pos_rccd,
        pos_rccr,
        pos_ssd,
        pos_sd,
        pos_itd,
        pos_itst,
        pos_od,
        pos_oc,
        pos_ic,
        pos_rc,
        pos_fa,
        pos_cont,
        pos_acc,
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
