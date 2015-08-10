class AddSprintPrepaidAssetApprovalStatusEnumToPerson < ActiveRecord::Migration
  def change
    add_column :people, :sprint_prepaid_asset_approval_status, :integer
  end
end
