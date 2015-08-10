class CreateDevicesDeviceStatesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :devices, :device_states, column_options: { null: false } do |t|
      t.index :device_id
      t.index :device_state_id
    end
  end
end
