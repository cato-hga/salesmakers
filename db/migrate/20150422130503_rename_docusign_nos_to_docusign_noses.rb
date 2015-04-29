class RenameDocusignNosToDocusignNoses < ActiveRecord::Migration
  def change
    rename_table :docusign_nos, :docusign_noses
  end
end
