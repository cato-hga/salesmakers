class RenamePersonTerminatePermissiontoDocusignNosPermission < ActiveRecord::Migration
  def change
    a = Permission.find_by key: 'person_terminate'
    a.update key: 'docusign_nos_terminate'
  end
end
