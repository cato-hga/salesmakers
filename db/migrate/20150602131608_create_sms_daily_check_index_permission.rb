class CreateSMSDailyCheckIndexPermission < ActiveRecord::Migration
  def up
    sms_group = PermissionGroup.create name: 'SalesMakers Support'
    check = Permission.create key: 'sms_daily_check_index',
                              description: 'can view the daily check page',
                              permission_group: sms_group
    sms = Position.find_by name: 'SalesMakers Support Member'
    ssd = Position.find_by name: 'Senior Software Developer'
    sd = Position.find_by name: 'Software Developer'
    sms.permissions << check
    ssd.permissions << check
    sd.permissions << check
  end

  def down
    sms = Position.find_by name: 'SalesMakers Support Member'
    ssd = Position.find_by name: 'Senior Software Developer'
    sd = Position.find_by name: 'Software Developer'
    check = Permission.find_by key: 'sms_daily_check_index'
    sms.permissions.delete check
    ssd.permissions.delete check
    sd.permissions.delete check
    check.delete
  end
end
