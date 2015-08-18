class AddVonageDeviceIdToVonageTransfer < ActiveRecord::Migration
  def change
    add_column :vonage_transfers, :vonage_device_id, :integer
  end
end
