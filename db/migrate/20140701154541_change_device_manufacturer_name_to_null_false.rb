class ChangeDeviceManufacturerNameToNullFalse < ActiveRecord::Migration
  def change
    change_column :device_manufacturers, :name, :string, null: false
  end
end
