class CreateHistoricalLocationAreas < ActiveRecord::Migration
  def change
    create_table :historical_location_areas do |t|
      t.integer :historical_location_id, null: false
      t.integer :historical_area_id, null: false
      t.integer :current_head_count, null: false, default: 0
      t.integer :potential_candidate_count, null: false, default: 0
      t.integer :target_head_count, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.float :hourly_rate
      t.integer :offer_extended_count, null: false, default: true
      t.boolean :outsourced
      t.integer :launch_group
      t.float :distance_to_cor
      t.integer :priority

      t.timestamps null: false
    end
  end
end
