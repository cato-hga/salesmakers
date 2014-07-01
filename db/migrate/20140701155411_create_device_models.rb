class CreateDeviceModels < ActiveRecord::Migration
  def change
    create_table :device_models do |t|
      t.string :name, null: false
      t.integer :device_manufacturer_id, null: false

      t.timestamps
    end
  end
end
