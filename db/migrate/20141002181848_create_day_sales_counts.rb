class CreateDaySalesCounts < ActiveRecord::Migration
  def change
    create_table :day_sales_counts do |t|
      t.date :day, null: false
      t.references :saleable, polymorphic: true, null: false
      t.integer :sales, default: 0, null: false

      t.timestamps
    end
  end
end
