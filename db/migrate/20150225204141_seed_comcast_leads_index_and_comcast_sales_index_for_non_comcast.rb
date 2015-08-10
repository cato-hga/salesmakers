class SeedComcastLeadsIndexAndComcastSalesIndexForNonComcast < ActiveRecord::Migration
  def self.up
    positions = Position.where hq: true

    comcast_permission_group = PermissionGroup.find_or_create_by name: 'Comcast'
    comcast_lead_index = Permission.find_or_create_by key: 'comcast_lead_index',
                                                      description: 'can view Comcast leads',
                                                      permission_group: comcast_permission_group

    comcast_sale_index = Permission.find_or_create_by key: 'comcast_sale_index',
                                                      description: 'can view Comcast sales',
                                                      permission_group: comcast_permission_group

    for position in positions do
      position.permissions << comcast_lead_index
      position.permissions << comcast_sale_index
    end
  end

  def self.down
    positions = Position.where hq: true

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
  end
end
