class AddTransferTimeToVonageTransfers < ActiveRecord::Migration
  def change
    add_column :vonage_transfers, :transfer_time, :datetime
    add_column :vonage_transfers, :rejection_time, :datetime
  end
end
