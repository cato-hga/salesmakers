class AddMasqueradePermission < ActiveRecord::Migration
  def up
    permission_group = PermissionGroup.find_by name: 'People' || return
    masquerade = Permission.create key: 'person_masquerade',
                                   description: 'masquerade as a person',
                                   permission_group: permission_group
    position = Position.find_by name: 'Senior Software Developer' || return
    position.permissions << masquerade if position
    position = Position.find_by name: 'Software Developer' || return
    position.permissions << masquerade if position
  end

  def down
    masquerade = Permission.find_by key: 'person_masquerade' || return
    position = Position.find_by name: 'Senior Software Developer'
    position.permissions.delete masquerade if position
    position = Position.find_by name: 'Software Developer'
    position.permissions.delete masquerade if position
    masquerade.destroy
  end
end
