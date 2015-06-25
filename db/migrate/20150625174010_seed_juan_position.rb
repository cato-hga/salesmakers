class SeedJuanPosition < ActiveRecord::Migration
  def up
    hr_admin = Position.find_by name: 'Human Resources Administrator'
    department = Department.find_by name: 'Operations'
    juan = Position.create name: 'Juan',
                           department: department,
                           all_field_visibility: true,
                           all_corporate_visibility: false,
                           leadership: true,
                           field: false,
                           hq: true
    juan.permissions << hr_admin.permissions
  end
end
