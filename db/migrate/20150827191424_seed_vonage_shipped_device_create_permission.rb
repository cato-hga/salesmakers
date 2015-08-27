class SeedVonageShippedDeviceCreatePermission < ActiveRecord::Migration
  def up
    permission_group = PermissionGroup.find_or_create_by name: 'Vonage'
    permission_group.permissions.create key: 'vonage_shipped_device_create',
                                        description: 'import shipped Vonage devices'
  end

  def down
    Permission.where(key: 'vonage_shipped_device_create').destroy_all
  end
end
