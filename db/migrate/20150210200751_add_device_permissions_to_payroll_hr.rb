class AddDevicePermissionsToPayrollHr < ActiveRecord::Migration
  def self.up
    payroll_administrator = Position.find_by name: 'Payroll Administrator'
    payroll_director = Position.find_by name: 'Payroll Director'
    human_resources_administrator = Position.find_by name: 'Human Resources Administrator'
    human_resources_director = Position.find_by name: 'Human Resources Director'
    device_index = Permission.find_by key: 'device_index'
    payroll_administrator.permissions << device_index
    payroll_director.permissions << device_index
    human_resources_administrator.permissions << device_index
    human_resources_director.permissions << device_index
  end

  def self.down
    payroll_administrator = Position.find_by name: 'Payroll Administrator'
    payroll_director = Position.find_by name: 'Payroll Director'
    human_resources_administrator = Position.find_by name: 'Human Resources Administrator'
    human_resources_director = Position.find_by name: 'Human Resources Director'
    device_index = Permission.find_by key: 'device_index'
    payroll_administrator.permissions << device_index
    payroll_director.permissions << device_index
    human_resources_administrator.permissions.delete(device_index)
    human_resources_director.permissions.delete(device_index)
  end
end
