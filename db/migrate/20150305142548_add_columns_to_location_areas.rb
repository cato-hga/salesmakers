class AddColumnsToLocationAreas < ActiveRecord::Migration
  def change
    add_column :location_areas, :current_head_count, :integer, null: false, default: 0
    add_column :location_areas, :potential_candidate_count, :integer, null: false, default: 0
    add_column :location_areas, :target_head_count, :integer, null: false, default: 0
  end
end
