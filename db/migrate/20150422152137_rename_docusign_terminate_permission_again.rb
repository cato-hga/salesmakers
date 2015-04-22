class RenameDocusignTerminatePermissionAgain < ActiveRecord::Migration
  def change
    a = Permission.find_by key: 'docusign_nos_terminate'
    a.update key: 'person_terminate'
  end
end
