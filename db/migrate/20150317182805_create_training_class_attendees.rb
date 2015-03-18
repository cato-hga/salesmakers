class CreateTrainingClassAttendees < ActiveRecord::Migration
  def change
    create_table :training_class_attendees do |t|
      t.integer :person_id, null: false
      t.integer :training_class_id, null: false
      t.boolean :attended, default: false, null: false
      t.datetime :dropped_off_time
      t.integer :drop_off_reason_id
      t.integer :status, null: false
      t.text :conditional_pass_condition
      t.boolean :group_me_setup, default: false, null: false
      t.boolean :time_clock_setup, default: false, null: false

      t.timestamps null: false
    end
  end
end
