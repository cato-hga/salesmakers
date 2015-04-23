class CreateWorkmarketFields < ActiveRecord::Migration
  def change
    create_table :workmarket_fields do |t|
      t.integer :workmarket_assignment_id, null: false
      t.string :name, null: false
      t.string :value, null: false

      t.timestamps null: false
    end
  end
end
