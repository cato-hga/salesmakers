class CreateDirecTVSales < ActiveRecord::Migration
  def change
    create_table :directv_sales do |t|
      t.date :order_date, null: false
      t.integer :person_id
      t.integer :directv_customer_id, null: false
      t.string :order_number, null: false
      t.integer :directv_former_provider_id
      t.integer :directv_lead_id
      t.boolean :customer_acknowledged, null: false

      t.timestamps null: false
    end
  end
end
