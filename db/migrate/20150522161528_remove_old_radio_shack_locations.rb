class RemoveOldRadioShackLocations < ActiveRecord::Migration
  def self.up
    locations = Location.where channel_id: 9, store_number: 'N/A'
    for location in locations do
      location.location_areas.each do |la|
        la.candidates.each do |c|
          c.update_column :location_area_id, nil
        end
        la.radio_shack_location_schedules.clear
        la.day_sales_counts.destroy_all
      end
      location.destroy
    end
  end
end
