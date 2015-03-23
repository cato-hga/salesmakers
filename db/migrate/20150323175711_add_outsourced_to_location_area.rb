class AddOutsourcedToLocationArea < ActiveRecord::Migration
  def change
    add_column :location_areas, :outsourced, :boolean, null: false, default: false
  end
end
