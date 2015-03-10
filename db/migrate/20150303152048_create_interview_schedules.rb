class CreateInterviewSchedules < ActiveRecord::Migration
  def change
    create_table :interview_schedules do |t|
      t.integer :candidate_id, null: false
      t.integer :person_id, null: false
      t.datetime :start_time, null: false

      t.timestamps null: false
    end
  end
end
