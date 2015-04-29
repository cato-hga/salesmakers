class AddTerminatePermissionToHqPositions < ActiveRecord::Migration
  def change
    group = PermissionGroup.find_or_create_by name: 'People'
    terminate = Permission.create key: 'person_terminate',
                                  permission_group: group,
                                  description: 'can terminate people outside of their managed team members'


    hr_dir = Position.find_by name: 'Human Resources Director'
    hr_admin = Position.find_by name: 'Human Resources Administrator'
    ssd = Position.find_by name: 'Senior Software Developer'
    sd = Position.find_by name: 'Software Developer'

    positions = [hr_dir, hr_admin, ssd, sd]
    for position in positions
      position.permissions << terminate
      position.save
    end

  end
end
