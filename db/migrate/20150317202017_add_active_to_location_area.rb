class AddActiveToLocationArea < ActiveRecord::Migration
  def change
    add_column :location_areas, :active, :boolean, null: false, default: true
  end
end
