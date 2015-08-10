class RemoveOldRadioShackLocations < ActiveRecord::Migration
  def self.up
    locations = Location.where channel_id: 9, store_number: 'N/A'
    for location in locations do
      has_candidates = false
      location.location_areas.each do |la|
        if la.candidates.count > 0
          has_candidates = true
          next
        end
        la.radio_shack_location_schedules.clear
        la.day_sales_counts.destroy_all
      end
      next if has_candidates
      location.destroy
    end
  end
end
