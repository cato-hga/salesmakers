class ChangeCandidateSchedulingDismissals < ActiveRecord::Migration
  def change
    add_column :candidate_scheduling_dismissals, :monday_start, :datetime
    add_column :candidate_scheduling_dismissals, :monday_end, :datetime
    add_column :candidate_scheduling_dismissals, :tuesday_start, :datetime
    add_column :candidate_scheduling_dismissals, :tuesday_end, :datetime
    add_column :candidate_scheduling_dismissals, :wednesday_start, :datetime
    add_column :candidate_scheduling_dismissals, :wednesday_end, :datetime
    add_column :candidate_scheduling_dismissals, :thursday_start, :datetime
    add_column :candidate_scheduling_dismissals, :thursday_end, :datetime
    add_column :candidate_scheduling_dismissals, :friday_start, :datetime
    add_column :candidate_scheduling_dismissals, :friday_end, :datetime
    add_column :candidate_scheduling_dismissals, :saturday_start, :datetime
    add_column :candidate_scheduling_dismissals, :saturday_end, :datetime
    add_column :candidate_scheduling_dismissals, :sunday_start, :datetime
    add_column :candidate_scheduling_dismissals, :sunday_end, :datetime
  end
end
