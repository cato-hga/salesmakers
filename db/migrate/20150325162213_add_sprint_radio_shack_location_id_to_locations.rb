class AddSprintRadioShackLocationIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :sprint_radio_shack_location_id, :integer
  end
end
