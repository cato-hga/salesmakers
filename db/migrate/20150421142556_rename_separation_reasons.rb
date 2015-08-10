class RenameSeparationReasons < ActiveRecord::Migration
  def change
    rename_column :docusign_nos, :separation_reason_id, :employment_end_reason_id
  end
end
