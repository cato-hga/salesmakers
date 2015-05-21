class SeedLocationIndexAndShowPermissions < ActiveRecord::Migration
  def self.up
    permission_group = PermissionGroup.find_or_create_by name: 'Locations'
    permission_index = Permission.find_or_create_by key: 'location_index',
                                                     description: "show locations list",
                                                     permission_group: permission_group
    permission_show = Permission.find_or_create_by key: 'location_show',
                                                     description: "show individual locations",
                                                     permission_group: permission_group
    for position in get_positions do
      position.permissions << permission_index
      position.permissions << permission_show
    end
  end

  def self.down
    permission_group = PermissionGroup.find_or_create_by name: 'Locations'
    permission_index = Permission.find_or_create_by key: 'location_index',
                                                    description: "show locations list",
                                                    permission_group: permission_group
    permission_show = Permission.find_or_create_by key: 'location_show',
                                                   description: "show individual locations",
                                                   permission_group: permission_group
    for position in get_positions do
      position.permissions.delete permission_index
      position.permissions.delete permission_show
    end
  end

  def get_positions
    pos_admin = Position.find_by_name 'System Administrator'

    pos_ssd = Position.find_by_name 'Senior Software Developer'
    pos_sd = Position.find_by_name 'Software Developer'
    pos_itd = Position.find_by_name 'Information Technology Director'
    pos_itst = Position.find_by_name 'Information Technology Support Technician'

    pos_od = Position.find_by_name 'Operations Director'
    pos_oc = Position.find_by_name 'Operations Coordinator'
    pos_rc = Position.find_by_name 'Reporting Coordinator'

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
        pos_ssd,
        pos_sd,
        pos_itd,
        pos_itst,
        pos_od,
        pos_oc,
        pos_rc,
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
