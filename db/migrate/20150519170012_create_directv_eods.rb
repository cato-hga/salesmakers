class CreateDirecTVEods < ActiveRecord::Migration
  def change
    create_table :directv_eods do |t|
      t.boolean "cloud_training", default: false, null: false
      t.text "cloud_training_takeaway"
      t.boolean "directv_visit", default: false, null: false
      t.text "directv_visit_takeaway"
      t.datetime "eod_date", null: false
      t.integer "location_id", null: false
      t.integer "person_id"
      t.boolean "sales_pro_visit", default: false, null: false
      t.text "sales_pro_visit_takeaway"
      t.timestamps null: false
    end
  end
end
