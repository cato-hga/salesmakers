class ConvertStartTimeToDateTime < ActiveRecord::Migration
  def change
    remove_column :interview_schedules, :start_time
    add_column :interview_schedules, :start_time, :datetime, null: false
  end
end
