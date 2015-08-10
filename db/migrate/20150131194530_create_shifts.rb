class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.integer :person_id, null: false
      t.integer :location_id
      t.date :date, null: false
      t.decimal :hours, null: false
      t.decimal :break_hours, null: false, default: 0.0

      t.timestamps null: false
    end
  end
end