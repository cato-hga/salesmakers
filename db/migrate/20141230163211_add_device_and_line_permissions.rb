class AddDeviceAndLinePermissions < ActiveRecord::Migration
  def self.up
    lines = PermissionGroup.find_by name: 'Lines'
    devices = PermissionGroup.find_by name: 'Devices'

    device_index = Permission.create key: 'device_index',
                                         description: "can view list of devices",
                                         permission_group: devices
    device_create = Permission.create key: 'device_create',
                                          description: "can create new devices",
                                          permission_group: devices
    device_update = Permission.create key: 'device_update',
                                          description: "can update existing devices",
                                          permission_group: devices
    device_destroy = Permission.create key: 'device_destroy',
                                           description: "can destroy devices",
                                           permission_group: devices
    line_index = Permission.create key: 'line_index',
                                         description: "can view list of lines",
                                         permission_group: lines
    line_create = Permission.create key: 'line_create',
                                          description: "can create new lines",
                                          permission_group: lines
    line_update = Permission.create key: 'line_update',
                                          description: "can update existing lines",
                                          permission_group: lines
    line_destroy = Permission.create key: 'line_destroy',
                                           description: "can destroy lines",
                                           permission_group: lines

    permissions = [
        line_index, line_create, line_update, line_destroy,
        device_index, device_create, device_update, device_destroy
    ]

    pos_admin = Position.find_by_name 'System Administrator'
    pos_ssd = Position.find_by_name 'Senior Software Developer'
    pos_sd = Position.find_by_name 'Software Developer'
    pos_itd = Position.find_by_name 'Information Technology Director'
    pos_itst = Position.find_by_name 'Information Technology Support Technician'

    pos_admin.permissions << permissions if pos_admin
    pos_ssd.permissions << permissions if pos_ssd
    pos_sd.permissions << permissions if pos_sd
    pos_itd.permissions << permissions if pos_itd
    pos_itst.permissions << permissions if pos_itst
  end
  
  def self.down
    Permission.where(key: 'line_index').destroy_all
    Permission.where(key: 'line_create').destroy_all
    Permission.where(key: 'line_update').destroy_all
    Permission.where(key: 'line_destroy').destroy_all
    Permission.where(key: 'device_index').destroy_all
    Permission.where(key: 'device_create').destroy_all
    Permission.where(key: 'device_update').destroy_all
    Permission.where(key: 'device_destroy').destroy_all

    pos_admin = Position.find_by_name 'System Administrator'
    pos_ssd = Position.find_by_name 'Senior Software Developer'
    pos_sd = Position.find_by_name 'Software Developer'
    pos_itd = Position.find_by_name 'Information Technology Director'
    pos_itst = Position.find_by_name 'Information Technology Support Technician'

    permissions = Array.new
    line_index = Permission.find_by key: 'line_index'
    line_create = Permission.find_by key: 'line_create'
    line_update = Permission.find_by key: 'line_update'
    line_destroy = Permission.find_by key: 'line_destroy'
    device_index = Permission.find_by key: 'device_index'
    device_create = Permission.find_by key: 'device_create'
    device_update = Permission.find_by key: 'device_update'
    device_destroy = Permission.find_by key: 'device_destroy'
    permissions << line_index if line_index
    permissions << line_create if line_create
    permissions << line_update if line_update
    permissions << line_destroy if line_destroy
    permissions << device_index if device_index
    permissions << device_create if device_create
    permissions << device_update if device_update
    permissions << device_destroy if device_destroy

    for permission in permissions do
      pos_admin.permissions.delete permission if pos_admin
      pos_ssd.permissions.delete permission if pos_ssd
      pos_sd.permissions.delete permission if pos_sd
      pos_itd.permissions.delete permission if pos_itd
      pos_itst.permissions.delete permission if pos_itst
    end
  end
end
