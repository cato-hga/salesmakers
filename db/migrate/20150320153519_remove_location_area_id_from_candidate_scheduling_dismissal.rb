class RemoveLocationAreaIdFromCandidateSchedulingDismissal < ActiveRecord::Migration
  def change
    remove_column :candidate_scheduling_dismissals, :location_area_id, :integer
  end
end
