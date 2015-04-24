class AddTableApprovalToPeople < ActiveRecord::Migration
  def change
    add_column :people, :vonage_tablet_approval_status, :integer, null: false, default: 0
  end
end
