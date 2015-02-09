class CreateVonageProducts < ActiveRecord::Migration
  def change
    create_table :vonage_products do |t|
      t.string :name, null: false
      t.decimal :price_range_minimum, null: false, default: 0.00
      t.decimal :price_range_maximum, null: false, default: 9999.99

      t.timestamps null: false
    end
  end
end
