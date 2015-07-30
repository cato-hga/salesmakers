class AddDateToHistoricalLocationArea < ActiveRecord::Migration
  def change
    add_column :historical_location_areas, :date, :date, null: false
  end
end
