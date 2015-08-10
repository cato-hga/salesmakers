class SeedSprintSaleIndexPermission < ActiveRecord::Migration
  def self.up
    permission_group = PermissionGroup.find_or_create_by name: 'Sprint'
    permission = Permission.create key: 'sprint_sale_index',
                                   description: 'view a list of Sprint sales',
                                   permission_group: permission_group
    for position in get_positions do
      position.permissions << permission
    end
  end

  def self.down
    permission = Permission.find_by key: 'sprint_sale_index'
    for position in get_positions do
      position.permissions.delete permission
    end
    permission_group = permission.permission_group
    permission.destroy
    permission_group.destroy
  end

  private

  def get_positions
    [
        Position.find_by(name: 'Chief Executive Officer'),
        Position.find_by(name: 'Chief Financial Officer'),
        Position.find_by(name: 'Chief Operations Officer'),
        Position.find_by(name: 'Executive Assistant'),
        Position.find_by(name: 'Information Technology Director'),
        Position.find_by(name: 'Information Technology Support Technician'),
        Position.find_by(name: 'Operations Coordinator'),
        Position.find_by(name: 'Operations Director'),
        Position.find_by(name: 'Quality Assurance Administrator'),
        Position.find_by(name: 'Quality Assurance Director'),
        Position.find_by(name: 'Reporting Coordinator'),
        Position.find_by(name: 'SalesMakers Support Member'),
        Position.find_by(name: 'Senior Software Developer'),
        Position.find_by(name: 'Software Developer'),
        Position.find_by(name: 'Sprint RadioShack SalesMaker'),
        Position.find_by(name: 'Sprint Retail Area Sales Manager'),
        Position.find_by(name: 'Sprint Retail Regional Manager'),
        Position.find_by(name: 'Sprint Retail Regional Vice President'),
        Position.find_by(name: 'Sprint Retail Sales Director'),
        Position.find_by(name: 'Sprint Retail Sales Specialist'),
        Position.find_by(name: 'Trainer'),
        Position.find_by(name: 'Training Director'),
        Position.find_by(name: 'Vice President of Sales'),
    ].compact
  end
end
