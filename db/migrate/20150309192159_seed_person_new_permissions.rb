class SeedPersonNewPermissions < ActiveRecord::Migration
  def self.up
    permission_group = PermissionGroup.find_or_create_by name: 'People'
    permission = Permission.create key: 'person_create',
                                   description: 'Can add new People',
                                   permission_group: permission_group
    for position in get_positions do
      position.permissions << permission
    end
  end

  def self.down
    permission = Permission.find_by key: 'person_create'
    for position in get_positions do
      position.permissions.delete permission
    end
    permission.destroy
  end

  private

  def get_positions
    pos_admin = Position.find_by_name 'System Administrator'
    pos_ssd = Position.find_by_name 'Senior Software Developer'
    pos_sd = Position.find_by_name 'Software Developer'
    pos_itd = Position.find_by_name 'Information Technology Director'
    pos_itst = Position.find_by_name 'Information Technology Support Technician'
    pos_od = Position.find_by_name 'Operations Director'
    pos_oc = Position.find_by_name 'Operations Coordinator'

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
        pos_pd,
        pos_pa,
        pos_hras,
        pos_hra
    ].compact
  end
end
