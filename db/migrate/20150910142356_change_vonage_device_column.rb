class ChangeVonageDeviceColumn < ActiveRecord::Migration
  def up
    remove_column :vonage_transfers, :vonage_device

  end
  def down
    add_column :vonage_transfers, :vonage_device, :string

  end
end
