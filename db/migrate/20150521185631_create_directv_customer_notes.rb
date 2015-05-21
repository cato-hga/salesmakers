class CreateDirecTVCustomerNotes < ActiveRecord::Migration
  def change
    create_table :directv_customer_notes do |t|
      t.integer "directv_customer_id", null: false
      t.datetime "created_at", null: false
      t.text "note", null: false
      t.integer "person_id", null: false
      t.datetime "updated_at", null: false
      t.timestamps null: false
    end
  end
end
