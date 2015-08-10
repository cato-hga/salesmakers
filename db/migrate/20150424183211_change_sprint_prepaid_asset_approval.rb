class ChangeSprintPrepaidAssetApproval < ActiveRecord::Migration
  def change
    change_column :people, :sprint_prepaid_asset_approval_status, :integer, default: 0, null: false
  end
end
