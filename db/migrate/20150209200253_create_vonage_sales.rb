class CreateVonageSales < ActiveRecord::Migration
  def change
    create_table :vonage_sales do |t|
      t.date :sale_date, null: false
      t.integer :person_id, null: false
      t.string :confirmation_number, null: false
      t.integer :location_id, null: false
      t.string :customer_first_name, null: false
      t.string :customer_last_name, null: false
      t.string :mac_id, null: false
      t.integer :vonage_product_id, null: false

      t.timestamps null: false
    end
  end
end
