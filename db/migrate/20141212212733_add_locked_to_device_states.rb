class AddLockedToDeviceStates < ActiveRecord::Migration
  def change
    add_column :device_states, :locked, :boolean, default: false
  end
end
