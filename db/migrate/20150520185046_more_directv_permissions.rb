class MoreDirecTVPermissions < ActiveRecord::Migration
  directv_permission_group = PermissionGroup.find_or_create_by name: 'DirecTV'
  directv_customer_index = Permission.find_or_create_by key: 'directv_customer_index',
                                                        description: 'can add new DirecTV customers',
                                                        permission_group: directv_permission_group

  hq_positions = Position.where hq: true
  for position in hq_positions do
    position.permissions << directv_customer_index
  end

  pos_dtrrvp = Position.find_by name: 'DirecTV Retail Regional Vice President'
  pos_dtrtm = Position.find_by name: 'DirecTV Retail Territory Manager'
  pos_dtrss = Position.find_by name: 'DirecTV Retail Sales Specialist'
  ssd = Position.find_by name: 'Senior Software Developer'
  sd = Position.find_by name: 'Software Developer'

  directv_positions = [pos_dtrrvp, pos_dtrtm, pos_dtrss, ssd, sd]
  for position in directv_positions do
    position.permissions << directv_customer_index

  end

end

def down
  directv_customer_index = Permission.find_by key: 'directv_customer_index'

  hq_positions = Position.where hq: true
  for position in hq_positions do
    position.permissions.delete directv_customer_index
  end

  pos_dtrrvp = Position.find_by name: 'DirecTV Retail Regional Vice President'
  pos_dtrtm = Position.find_by name: 'DirecTV Retail Territory Manager'
  pos_dtrss = Position.find_by name: 'DirecTV Retail Sales Specialist'
  ssd = Position.find_by name: 'Senior Software Developer'
  sd = Position.find_by name: 'Software Developer'

  directv_positions = [pos_dtrrvp, pos_dtrtm, pos_dtrss, ssd, sd]
  for position in directv_positions do
    position.permissions.delete directv_customer_index
  end
end
