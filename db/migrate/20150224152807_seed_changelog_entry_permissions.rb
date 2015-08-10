class SeedChangelogEntryPermissions < ActiveRecord::Migration
  def self.up
    permission_group = PermissionGroup.create name: 'Changelog'
    permission = Permission.create key: 'changelog_entry_manage',
                                   description: 'Manage software feature changes',
                                   permission_group: permission_group
    ssd = Position.find_by name: 'Senior Software Developer'
    sd = Position.find_by name: 'Software Developer'
    ssd.permissions << permission
    sd.permissions << permission
  end

  def self.down
    Permission.where(key: 'changelog_entry_manage').destroy_all
  end
end
