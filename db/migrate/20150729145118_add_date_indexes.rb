class AddDateIndexes < ActiveRecord::Migration
  def change
    add_index :historical_areas, :date
    add_index :historical_people, :date
    add_index :historical_locations, :date
    add_index :historical_person_areas, :date
    add_index :historical_location_areas, :date
    add_index :historical_client_areas, :date
    add_index :historical_person_client_areas, :date
    add_index :historical_location_client_areas, :date
  end
end
