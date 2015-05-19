class SeedDirecTVPermissions < ActiveRecord::Migration
  def up
    directv_permission_group = PermissionGroup.find_or_create_by name: 'DirecTV'
    directv_lead_index = Permission.find_or_create_by key: 'directv_lead_index',
                                                      description: 'can view DirecTV leads',
                                                      permission_group: directv_permission_group

    directv_sale_index = Permission.find_or_create_by key: 'directv_sale_index',
                                                      description: 'can view DirecTV sales',
                                                      permission_group: directv_permission_group
    directv_customer_update = Permission.find_or_create_by key: 'directv_customer_update',
                                                           description: 'can update DirecTV customers',
                                                           permission_group: directv_permission_group
    directv_customer_create = Permission.find_or_create_by key: 'directv_customer_create',
                                                           description: 'can add new DirecTV customers',
                                                           permission_group: directv_permission_group

    directv_sale_create = Permission.find_or_create_by key: 'directv_sale_create',
                                                       description: 'can add new DirecTV sales',
                                                       permission_group: directv_permission_group

    hq_positions = Position.where hq: true
    for position in hq_positions do
      position.permissions << directv_lead_index
      position.permissions << directv_sale_index
    end

    pos_dtrrvp = Position.find_by name: 'DirecTV Retail Regional Vice President'
    pos_dtrtm = Position.find_by name: 'DirecTV Retail Territory Manager'
    pos_dtrss = Position.find_by name: 'DirecTV Retail Sales Specialist'
    ssd = Position.find_by name: 'Senior Software Developer'
    sd = Position.find_by name: 'Software Developer'

    directv_positions = [pos_dtrrvp, pos_dtrtm, pos_dtrss, ssd, sd]
    for position in directv_positions do
      position.permissions << directv_lead_index
      position.permissions << directv_sale_index
      position.permissions << directv_customer_update
      position.permissions << directv_customer_create
      position.permissions << directv_sale_create
    end

  end

  def down
    directv_lead_index = Permission.find_by key: 'directv_lead_index'
    directv_sale_index = Permission.find_by key: 'directv_sale_index'
    directv_customer_update = Permission.find_by key: 'directv_customer_update'
    directv_customer_create = Permission.find_by key: 'directv_customer_create'
    directv_sale_create = Permission.find_by key: 'directv_sale_create'

    hq_positions = Position.where hq: true
    for position in hq_positions do
      position.permissions.delete directv_lead_index
      position.permissions.delete directv_sale_index
    end

    pos_dtrrvp = Position.find_by name: 'DirecTV Retail Regional Vice President'
    pos_dtrtm = Position.find_by name: 'DirecTV Retail Territory Manager'
    pos_dtrss = Position.find_by name: 'DirecTV Retail Sales Specialist'
    ssd = Position.find_by name: 'Senior Software Developer'
    sd = Position.find_by name: 'Software Developer'

    directv_positions = [pos_dtrrvp, pos_dtrtm, pos_dtrss, ssd, sd]
    for position in directv_positions do
      position.permissions.delete directv_lead_index
      position.permissions.delete directv_sale_index
      position.permissions.delete directv_customer_update
      position.permissions.delete directv_customer_create
      position.permissions.delete directv_sale_create
    end
  end

end
