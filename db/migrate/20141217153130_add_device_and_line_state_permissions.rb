class AddDeviceAndLineStatePermissions < ActiveRecord::Migration
  def self.up
    lines = PermissionGroup.create name: 'Lines'
    devices = PermissionGroup.create name: 'Devices'

    line_state_index = Permission.create key: 'line_state_index',
                                          description: "can view list of line states",
                                          permission_group: lines
    line_state_create = Permission.create key: 'line_state_create',
                                          description: "can create new line states",
                                          permission_group: lines
    line_state_update = Permission.create key: 'line_state_update',
                                          description: "can update existing line states",
                                          permission_group: lines
    line_state_destroy = Permission.create key: 'line_state_destroy',
                                          description: "can destroy line states",
                                          permission_group: lines
    
    device_state_index = Permission.create key: 'device_state_index',
                                          description: "can view list of device states",
                                          permission_group: devices
    device_state_create = Permission.create key: 'device_state_create',
                                          description: "can create new device states",
                                          permission_group: devices
    device_state_update = Permission.create key: 'device_state_update',
                                          description: "can update existing device states",
                                          permission_group: devices
    device_state_destroy = Permission.create key: 'device_state_destroy',
                                          description: "can destroy device states",
                                          permission_group: devices
    permissions = [
        line_state_index, line_state_create, line_state_update, line_state_destroy,
        device_state_index, device_state_create, device_state_update, device_state_destroy
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
    Permission.where(key: 'line_state_index').destroy_all
    Permission.where(key: 'line_state_create').destroy_all
    Permission.where(key: 'line_state_update').destroy_all
    Permission.where(key: 'line_state_destroy').destroy_all
    Permission.where(key: 'device_state_index').destroy_all
    Permission.where(key: 'device_state_create').destroy_all
    Permission.where(key: 'device_state_update').destroy_all
    Permission.where(key: 'device_state_destroy').destroy_all
    PermissionGroup.where(name: 'Lines').destroy_all
    PermissionGroup.where(name: 'Devices').destroy_all

    pos_admin = Position.find_by_name 'System Administrator'
    pos_ssd = Position.find_by_name 'Senior Software Developer'
    pos_sd = Position.find_by_name 'Software Developer'
    pos_itd = Position.find_by_name 'Information Technology Director'
    pos_itst = Position.find_by_name 'Information Technology Support Technician'

    permissions = Array.new
    line_state_index = Permission.find_by key: 'line_state_index'
    line_state_create = Permission.find_by key: 'line_state_create'
    line_state_update = Permission.find_by key: 'line_state_update'
    line_state_destroy = Permission.find_by key: 'line_state_destroy'
    device_state_index = Permission.find_by key: 'device_state_index'
    device_state_create = Permission.find_by key: 'device_state_create'
    device_state_update = Permission.find_by key: 'device_state_update'
    device_state_destroy = Permission.find_by key: 'device_state_destroy'
    permissions << line_state_index if line_state_index
    permissions << line_state_create if line_state_create
    permissions << line_state_update if line_state_update
    permissions << line_state_destroy if line_state_destroy
    permissions << device_state_index if device_state_index
    permissions << device_state_create if device_state_create
    permissions << device_state_update if device_state_update
    permissions << device_state_destroy if device_state_destroy

    for permission in permissions do
      pos_admin.permissions.delete permission if pos_admin
      pos_ssd.permissions.delete permission if pos_ssd
      pos_sd.permissions.delete permission if pos_sd
      pos_itd.permissions.delete permission if pos_itd
      pos_itst.permissions.delete permission if pos_itst
    end
  end
end
