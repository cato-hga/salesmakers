class AddActiveToInterviewSchedule < ActiveRecord::Migration
  def change
    add_column :interview_schedules, :active, :boolean
  end
end
