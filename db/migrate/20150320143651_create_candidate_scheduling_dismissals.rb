class CreateCandidateSchedulingDismissals < ActiveRecord::Migration
  def change
    create_table :candidate_scheduling_dismissals do |t|
      t.integer :candidate_id, null: false
      t.integer :location_area_id, null: false
      t.text :comment, null: false

      t.timestamps null: false
    end
  end
end
