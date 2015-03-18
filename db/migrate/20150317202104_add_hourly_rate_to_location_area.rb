class AddHourlyRateToLocationArea < ActiveRecord::Migration
  def change
    add_column :location_areas, :hourly_rate, :float
  end
end
