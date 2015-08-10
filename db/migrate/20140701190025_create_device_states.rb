class CreateDeviceStates < ActiveRecord::Migration
  def change
    create_table :device_states do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
