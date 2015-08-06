class CreateVonageTransfers < ActiveRecord::Migration
  def change
    create_table :vonage_transfers do |t|
      t.string "to_person"
      t.string "from_person"
      t.string "vonage_device"
      t.datetime "transfer-time", null: false
      t.datetime "created_at", null: false
      t.boolean "accepted", default: false, null: false
      t.datetime "rejection-time", null: false
      t.timestamps null: false
    end
  end
end
