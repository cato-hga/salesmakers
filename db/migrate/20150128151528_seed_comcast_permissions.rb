class SeedComcastPermissions < ActiveRecord::Migration
  def self.up
    pos_ccrrvp = Position.find_by name: 'Comcast Retail Regional Vice President'
    pos_ccrtm = Position.find_by name: 'Comcast Retail Territory Manager'
    pos_ccrss = Position.find_by name: 'Comcast Retail Sales Specialist'
    comcast_positions = [pos_ccrrvp, pos_ccrtm, pos_ccrss]

    comcast_permission_group = PermissionGroup.find_or_create_by name: 'Comcast'
    comcast_customer_create = Permission.find_or_create_by key: 'comcast_customer_create',
                                                           description: 'can add new Comcast customers',
                                                           permission_group: comcast_permission_group

    comcast_sale_create = Permission.find_or_create_by key: 'comcast_sale_create',
                                                       description: 'can add new Comcast sales',
                                                       permission_group: comcast_permission_group

    for position in comcast_positions do
      position.permissions << comcast_customer_create
      position.permissions << comcast_sale_create
    end
  end

  def self.down
    pos_ccrrvp = Position.find_by name: 'Comcast Retail Regional Vice President'
    pos_ccrtm = Position.find_by name: 'Comcast Retail Territory Manager'
    pos_ccrss = Position.find_by name: 'Comcast Retail Sales Specialist'
    comcast_positions = [pos_ccrrvp, pos_ccrtm, pos_ccrss]
    comcast_permission_group = PermissionGroup.find_or_create_by name: 'Comcast'
    comcast_customer_create = Permission.find_or_create_by key: 'comcast_customer_create',
                                                           description: 'can add new Comcast customers',
                                                           permission_group: comcast_permission_group

    comcast_sale_create = Permission.find_or_create_by key: 'comcast_sale_create',
                                                       description: 'can add new Comcast sales',
                                                       permission_group: comcast_permission_group
    for position in comcast_positions do
      position.permissions.delete comcast_customer_create
      position.permissions.delete comcast_sale_create
    end
    comcast_customer_create.destroy
    comcast_sale_create.destroy
    comcast_permission_group.destroy
  end
end
