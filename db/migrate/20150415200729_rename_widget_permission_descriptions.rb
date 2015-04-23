class RenameWidgetPermissionDescriptions < ActiveRecord::Migration
  def self.up
    permission_group = PermissionGroup.find_by name: 'Widgets'
    for permission in permission_group.permissions do
      permission.update description: permission.description.gsub('view list the', 'view the ')
    end
  end
end
