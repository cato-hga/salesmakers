class CreateRadioShackLocationSchedules < ActiveRecord::Migration
  def change
    create_table :radio_shack_location_schedules do |t|
      t.string :name, null: false
      t.string :time_range, null: false
      t.boolean :active, default: true, null: false

      t.timestamps null: false
    end
  end
end
