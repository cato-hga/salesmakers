class SeedRadioShackLocationsWithRadioShackLocationSchedules < ActiveRecord::Migration
  def up
    radioshack_areas = Area.where(project_id: 6)
    location_areas = []
    for area in radioshack_areas do
      location_area = LocationArea.find_by area_id: area.id
      location_areas << location_area
    end
  end
end
