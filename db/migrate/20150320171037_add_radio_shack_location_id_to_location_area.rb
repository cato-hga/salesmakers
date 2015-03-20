class AddRadioShackLocationIdToLocationArea < ActiveRecord::Migration
  def change
    add_column :location_areas, :radio_shack_location_schedule_id, :integer
  end
end
