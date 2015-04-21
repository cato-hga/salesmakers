class CreateSprintSales < ActiveRecord::Migration
  def change
    create_table :sprint_sales do |t|
      t.date :sale_date, null: false
      t.integer :person_id, null: false
      t.integer :location_id, null: false
      t.string :meid, null: false
      t.string :mobile_phone, null: false
      t.string :carrier_name, null: false
      t.string :model_name, null: false
      t.boolean :upgrade, null: false, default: false
      t.string :rate_plan_name, null: false
      t.boolean :top_up_card_purchased, null: false, default: false
      t.float :top_up_card_amount
      t.boolean :phone_activated_in_store, null: false, default: false
      t.string :reason_not_activated_in_store
      t.string :picture_with_customer, null: false
      t.text :comments
      t.string :connect_sprint_sale_id

      t.timestamps null: false
    end
  end
end
