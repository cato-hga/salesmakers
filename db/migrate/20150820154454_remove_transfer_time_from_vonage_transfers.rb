class RemoveTransferTimeFromVonageTransfers < ActiveRecord::Migration
  def change
    remove_column :vonage_transfers, 'transfer-time'
  end
end
