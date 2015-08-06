class CreateVonageDevices < ActiveRecord::Migration
  def change
    create_table :vonage_devices do |t|

      t.timestamps null: false
      t.string "mac_id"
      t.string "po_number"
      t.integer "person_id"
      t.datetime "receive_date"
    end
  end
end
