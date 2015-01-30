class SeedComcastCustomersIndexPermissions < ActiveRecord::Migration
  def self.up
    permission = get_permission
    for position in get_positions do
      next unless position and permission
      position.permissions << permission
    end
  end

  def self.down
    permission = get_permission
    for position in get_positions do
      next unless position and permission
      position.permissions.delete permission
    end
  end

  private

  def get_positions
    positions = Array.new
    positions << Position.find_by(name: 'Comcast Retail Regional Vice President')
    positions << Position.find_by(name: 'Comcast Retail Territory Manager')
    positions << Position.find_by(name: 'Comcast Retail Sales Specialist')
    positions
  end

  def get_permission
    group = PermissionGroup.find_by name: 'Comcast'
    Permission.find_or_create_by key: 'comcast_customer_index',
                                 description: 'can view Comcast customers',
                                 permission_group: group
  end
end
