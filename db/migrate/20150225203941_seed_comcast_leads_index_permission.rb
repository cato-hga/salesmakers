class SeedComcastLeadsIndexPermission < ActiveRecord::Migration
  def self.up
    pos_ccrrvp = Position.find_by name: 'Comcast Retail Regional Vice President'
    pos_ccrtm = Position.find_by name: 'Comcast Retail Territory Manager'
    pos_ccrss = Position.find_by name: 'Comcast Retail Sales Specialist'
    comcast_positions = [pos_ccrrvp, pos_ccrtm, pos_ccrss]

    comcast_permission_group = PermissionGroup.find_or_create_by name: 'Comcast'
    comcast_lead_index = Permission.find_or_create_by key: 'comcast_lead_index',
                                                           description: 'can view Comcast leads',
                                                           permission_group: comcast_permission_group

    comcast_sale_index = Permission.find_or_create_by key: 'comcast_sale_index',
                                                       description: 'can view Comcast sales',
                                                       permission_group: comcast_permission_group

    for position in comcast_positions do
      position.permissions << comcast_lead_index
      position.permissions << comcast_sale_index
    end
  end

  def self.down
    pos_ccrrvp = Position.find_by name: 'Comcast Retail Regional Vice President'
    pos_ccrtm = Position.find_by name: 'Comcast Retail Territory Manager'
    pos_ccrss = Position.find_by name: 'Comcast Retail Sales Specialist'
    comcast_positions = [pos_ccrrvp, pos_ccrtm, pos_ccrss]
    comcast_permission_group = PermissionGroup.find_or_create_by name: 'Comcast'
    comcast_lead_index = Permission.find_or_create_by key: 'comcast_lead_index',
                                                      description: 'can view Comcast leads',
                                                      permission_group: comcast_permission_group

    comcast_sale_index = Permission.find_or_create_by key: 'comcast_sale_index',
                                                      description: 'can view Comcast sales',
                                                      permission_group: comcast_permission_group
    for position in comcast_positions do
      position.permissions.delete comcast_lead_index
      position.permissions.delete comcast_sale_index
    end
    comcast_lead_index.destroy
    comcast_sale_index.destroy
  end
end
