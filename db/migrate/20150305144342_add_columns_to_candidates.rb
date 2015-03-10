class AddColumnsToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :person_id, :integer
    add_column :candidates, :location_area_id, :integer
  end
end
