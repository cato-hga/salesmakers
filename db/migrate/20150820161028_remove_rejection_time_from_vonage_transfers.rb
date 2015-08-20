class RemoveRejectionTimeFromVonageTransfers < ActiveRecord::Migration
  def change
    remove_column :vonage_transfers, 'rejection-time'
  end
end
