class CreateSMSDailyCheckIndexPermission < ActiveRecord::Migration
  def up
    sms_group = PermissionGroup.create name: 'SalesMakers Support'
    check = Permission.create key: 'sms_daily_check_index',
                              description: 'can view the daily check page',
                              permission_group: sms_group
    sms = Position.find_by name: 'SalesMakers Support Member'
    sms.permissions << check
  end

  def down
    sms = Position.find_by name: 'SalesMakers Support Member'
    check = Permission.find_by key: 'sms_daily_check_index'
    sms.permissions.delete check
    check.delete
  end
end
