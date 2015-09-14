class AddBilingualToLocationAreas < ActiveRecord::Migration
  def change
    add_column :location_areas, :bilingual, :boolean, default: false
  end
end
