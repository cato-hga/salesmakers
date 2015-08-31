class SeedVonageSaleIndexPermission < ActiveRecord::Migration
  def up
    permission_group = PermissionGroup.where name: "Vonage"
    if permission_group.count > 1
      permission_group.last.permissions.destroy_all
      permission_group.last.destroy
    end
    permission_group = PermissionGroup.find_by name: 'Vonage'
    permissions = permission_group.permissions.where(key: 'vonage_sale_create')
    unless permissions.empty?
      permissions.first.update description: 'enter Vonage sales'
    end
    permission_group.permissions.create key: 'vonage_sale_index',
                                        description: 'view list of Vonage sales'
  end

  def down
    Permission.where(key: 'vonage_sale_index').destroy_all
  end
end
