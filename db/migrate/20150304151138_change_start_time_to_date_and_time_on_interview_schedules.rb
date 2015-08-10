class ChangeStartTimeToDateAndTimeOnInterviewSchedules < ActiveRecord::Migration
  def change
    change_column :interview_schedules, :start_time, :time
    add_column :interview_schedules, :interview_date, :date
  end
end
