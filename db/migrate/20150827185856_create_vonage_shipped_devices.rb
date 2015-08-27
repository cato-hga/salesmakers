class CreateVonageShippedDevices < ActiveRecord::Migration
  def change
    create_table :vonage_shipped_devices do |t|
      t.boolean :active, null: false, default: true
      t.string :po_number, null: false
      t.string :carrier
      t.string :tracking_number
      t.date :ship_date, null: false
      t.string :mac, null: false
      t.string :device_type
      t.integer :vonage_device_id

      t.timestamps null: false
    end
  end
end
