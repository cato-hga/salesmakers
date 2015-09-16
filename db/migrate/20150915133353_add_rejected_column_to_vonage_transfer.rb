class AddRejectedColumnToVonageTransfer < ActiveRecord::Migration
  def change
    add_column :vonage_transfers, :rejected, :boolean
  end
end
