class CreateRadioShackLocationAreasJoinTable < ActiveRecord::Migration
  def change
    create_join_table :location_areas, :radio_shack_location_schedules
  end
end
