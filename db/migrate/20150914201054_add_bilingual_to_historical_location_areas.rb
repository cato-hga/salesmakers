class AddBilingualToHistoricalLocationAreas < ActiveRecord::Migration
  def change
    add_column :historical_location_areas, :bilingual, :boolean, default: false
  end
end
