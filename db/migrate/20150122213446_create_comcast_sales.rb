class CreateComcastSales < ActiveRecord::Migration
  def change
    create_table :comcast_sales do |t|
      t.datetime :sale_date
      t.integer :person_id
      t.integer :comcast_customer_id
      t.string :order_number
      t.boolean :tv
      t.boolean :internet
      t.boolean :phone
      t.boolean :security
      t.boolean :customer_acknowledged

      t.timestamps null: false
    end
  end
end
