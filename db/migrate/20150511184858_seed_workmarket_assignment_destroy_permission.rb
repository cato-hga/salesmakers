class SeedWorkmarketAssignmentDestroyPermission < ActiveRecord::Migration
  def self.up
    group = PermissionGroup.find_by name: 'Workmarket'
    permission = Permission.create key: 'workmarket_assignment_destroy',
                                   description: 'destroy a Workmarket assignment',
                                   permission_group: group
    client = ClientRepresentative.find_by email: 'dripdrop@salesmakersinc.com'
    if client
      client.permissions << permission
    end
    client = ClientRepresentative.find_by email: 'sodastream@salesmakersinc.com'
    if client
      client.permissions << permission
    end
  end

  def self.down
    permission = Permission.find_by key: 'workmarket_assignment_destroy'
    return unless permission
    client = ClientRepresentative.find_by email: 'dripdrop@salesmakersinc.com'
    if client
      client.permissions.delete permission
    end
    client = ClientRepresentative.find_by email: 'sodastream@salesmakersinc.com'
    if client
      client.permissions.delete permission
    end
    permission.destroy
  end
end
