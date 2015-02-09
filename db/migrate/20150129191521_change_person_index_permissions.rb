class ChangePersonIndexPermissions < ActiveRecord::Migration
  def self.up
    permission = Permission.find_by key: 'person_index'
    return unless permission

    for position in get_not_reps_positions do
      next unless position
      position.permissions.delete permission
      position.permissions << permission
    end

    for position in get_reps_positions do
      next unless position
      position.permissions.delete permission
    end
  end
  
  def self.down
    permission = Permission.find_by key: 'person_index'
    return unless permission

    for position in get_not_reps_positions.merge(get_reps_positions) do
      next unless position
      position.permissions.delete permission
      position.permissions << permission
    end
  end

  def get_not_reps_positions
    pos_admin = Position.find_by name: 'System Administrator'
    pos_vrrvp = Position.find_by name: 'Vonage Retail Regional Vice President'
    pos_vrrm = Position.find_by name: 'Vonage Retail Regional Manager'
    pos_vrasm = Position.find_by name: 'Vonage Retail Area Sales Manager'
    pos_vrtm = Position.find_by name: 'Vonage Retail Territory Manager'


    pos_vervp = Position.find_by name: 'Vonage Event Regional Vice President'
    pos_verm = Position.find_by name: 'Vonage Event Regional Manager'
    pos_veasm = Position.find_by name: 'Vonage Event Area Sales Manager'
    pos_vetl = Position.find_by name: 'Vonage Event Team Leader'
    pos_velit = Position.find_by name: 'Vonage Event Leader in Training'

    pos_srrvp = Position.find_by name: 'Sprint Retail Regional Vice President'
    pos_srrm = Position.find_by name: 'Sprint Retail Regional Manager'
    pos_srasm = Position.find_by name: 'Sprint Retail Area Sales Manager'
    pos_srtm = Position.find_by name: 'Sprint Retail Sales Director'

    pos_ccrrvp = Position.find_by name: 'Comcast Retail Regional Vice President'
    pos_ccrtm = Position.find_by name: 'Comcast Retail Territory Manager'

    pos_td = Position.find_by name: 'Training Director'
    pos_t = Position.find_by name: 'Trainer'

    pos_advd = Position.find_by name: 'Advocate Director'
    pos_advs = Position.find_by name: 'Advocate Supervisor'
    pos_adv = Position.find_by name: 'Advocate'
    pos_rccd = Position.find_by name: 'Recruiting Call Center Director'
    pos_rccr = Position.find_by name: 'Recruiting Call Center Representative'

    pos_ssd = Position.find_by name: 'Senior Software Developer'
    pos_sd = Position.find_by name: 'Software Developer'
    pos_itd = Position.find_by name: 'Information Technology Director'
    pos_itst = Position.find_by name: 'Information Technology Support Technician'

    pos_od = Position.find_by name: 'Operations Director'
    pos_oc = Position.find_by name: 'Operations Coordinator'
    pos_ic = Position.find_by name: 'Inventory Coordinator'
    pos_rc = Position.find_by name: 'Reporting Coordinator'

    pos_fa = Position.find_by name: 'Finance Administrator'
    pos_cont = Position.find_by name: 'Controller'
    pos_acc = Position.find_by name: 'Accountant'

    pos_md = Position.find_by name: 'Marketing Director'

    pos_qad = Position.find_by name: 'Quality Assurance Director'
    pos_qaa = Position.find_by name: 'Quality Assurance Administrator'

    pos_ceo = Position.find_by name: 'Chief Executive Officer'
    pos_coo = Position.find_by name: 'Chief Operations Officer'
    pos_cfo = Position.find_by name: 'Chief Financial Officer'
    pos_vps = Position.find_by name: 'Vice President of Sales'
    pos_ea = Position.find_by name: 'Executive Assistant'

    pos_pd = Position.find_by name: 'Payroll Director'
    pos_pa = Position.find_by name: 'Payroll Administrator'

    pos_hras = Position.find_by name: 'Human Resources Director'
    pos_hra = Position.find_by name: 'Human Resources Administrator'

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
    ]
  end

  def get_reps_positions
    pos_vrss = Position.find_by name: 'Vonage Retail Sales Specialist'
    pos_vess = Position.find_by name: 'Vonage Event Sales Specialist'
    pos_srss = Position.find_by name: 'Sprint Retail Sales Specialist'
    pos_ccrss = Position.find_by name: 'Comcast Retail Sales Specialist'
    pos_uf = Position.find_by name: 'Unclassified Field Employee'
    pos_uc = Position.find_by name: 'Unclassified HQ Employee'

    [
        pos_vrss,
        pos_vess,
        pos_srss,
        pos_ccrss,
        pos_uc,
        pos_uf
    ]
  end

end
