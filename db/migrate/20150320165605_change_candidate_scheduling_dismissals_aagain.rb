class ChangeCandidateSchedulingDismissalsAagain < ActiveRecord::Migration
  def change
    remove_column :candidate_scheduling_dismissals, :monday_start, :datetime
    remove_column :candidate_scheduling_dismissals, :monday_end, :datetime
    remove_column :candidate_scheduling_dismissals, :tuesday_start, :datetime
    remove_column :candidate_scheduling_dismissals, :tuesday_end, :datetime
    remove_column :candidate_scheduling_dismissals, :wednesday_start, :datetime
    remove_column :candidate_scheduling_dismissals, :wednesday_end, :datetime
    remove_column :candidate_scheduling_dismissals, :thursday_start, :datetime
    remove_column :candidate_scheduling_dismissals, :thursday_end, :datetime
    remove_column :candidate_scheduling_dismissals, :friday_start, :datetime
    remove_column :candidate_scheduling_dismissals, :friday_end, :datetime
    remove_column :candidate_scheduling_dismissals, :saturday_start, :datetime
    remove_column :candidate_scheduling_dismissals, :saturday_end, :datetime
    remove_column :candidate_scheduling_dismissals, :sunday_start, :datetime
    remove_column :candidate_scheduling_dismissals, :sunday_end, :datetime
    add_column :candidate_scheduling_dismissals, :monday_am, :datetime
    add_column :candidate_scheduling_dismissals, :monday_pm, :boolean
    add_column :candidate_scheduling_dismissals, :tuesday_am, :boolean
    add_column :candidate_scheduling_dismissals, :tuesday_pm, :boolean
    add_column :candidate_scheduling_dismissals, :wednesday_am, :boolean
    add_column :candidate_scheduling_dismissals, :wednesday_pm, :boolean
    add_column :candidate_scheduling_dismissals, :thursday_am, :boolean
    add_column :candidate_scheduling_dismissals, :thursday_pm, :boolean
    add_column :candidate_scheduling_dismissals, :friday_am, :boolean
    add_column :candidate_scheduling_dismissals, :friday_pm, :boolean
    add_column :candidate_scheduling_dismissals, :saturday_am, :boolean
    add_column :candidate_scheduling_dismissals, :saturday_pm, :boolean
    add_column :candidate_scheduling_dismissals, :sunday_am, :boolean
    add_column :candidate_scheduling_dismissals, :sunday_pm, :boolean
  end
end
