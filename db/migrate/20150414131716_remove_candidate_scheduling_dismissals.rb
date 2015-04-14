class RemoveCandidateSchedulingDismissals < ActiveRecord::Migration
  def change
    drop_table :candidate_scheduling_dismissals
  end
end
