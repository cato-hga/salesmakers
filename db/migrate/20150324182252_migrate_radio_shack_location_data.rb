class MigrateRadioShackLocationData < ActiveRecord::Migration
  def change
    a1pt2 = RadioShackLocationSchedule.find_by_name 'A1PT2'
    execute 'insert into location_areas_radio_shack_location_schedules
             select	location_areas.id,
                    location_areas.radio_shack_location_schedule_id
              from location_areas
              where location_areas.radio_shack_location_schedule_id is not null;'
    execute "insert into location_areas_radio_shack_location_schedules
            select	location_areas.id,
                    #{a1pt2.id}
              from location_areas
              where location_areas.radio_shack_location_schedule_id = 1;"

    remove_column :location_areas, :radio_shack_location_schedule_id
    a2p1 = RadioShackLocationSchedule.find_by_name 'A2PT1'
    a2p2 = RadioShackLocationSchedule.find_by_name 'A2PT2'
    location1 = Location.find_by store_number: '6482'
    location2 = Location.find_by store_number: '7565'
    location_area1 = LocationArea.find_by location: location1
    location_area2 = LocationArea.find_by location: location2
    execute "insert into location_areas_radio_shack_location_schedules values (#{location_area1.id},#{a2p1.id});"
    execute "insert into location_areas_radio_shack_location_schedules values (#{location_area1.id},#{a2p2.id});"
    execute "insert into location_areas_radio_shack_location_schedules values (#{location_area2.id},#{a2p1.id});"
    execute "insert into location_areas_radio_shack_location_schedules values (#{location_area2.id},#{a2p2.id});"
  end
end
