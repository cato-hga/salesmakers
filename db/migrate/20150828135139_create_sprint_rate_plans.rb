class CreateSprintRatePlans < ActiveRecord::Migration
  def change
    create_table :sprint_rate_plans do |t|
      t.string :name
      t.integer :carrier_id

      t.timestamps null: false
    end
  end
end
