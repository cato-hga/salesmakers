class AddDistanceCorToLocationArea < ActiveRecord::Migration
  def change
    add_column :location_areas, :distance_to_cor, :float
  end
end
