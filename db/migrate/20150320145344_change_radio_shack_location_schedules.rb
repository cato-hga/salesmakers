class ChangeRadioShackLocationSchedules < ActiveRecord::Migration
  def change
    remove_column :radio_shack_location_schedules, :time_range
    add_column :radio_shack_location_schedules, :monday, :float, null: false, default: 0
    add_column :radio_shack_location_schedules, :tuesday, :float, null: false, default: 0
    add_column :radio_shack_location_schedules, :wednesday, :float, null: false, default: 0
    add_column :radio_shack_location_schedules, :thursday, :float, null: false, default: 0
    add_column :radio_shack_location_schedules, :friday, :float, null: false, default: 0
    add_column :radio_shack_location_schedules, :saturday, :float, null: false, default: 0
    add_column :radio_shack_location_schedules, :sunday, :float, null: false, default: 0
  end
end
