class CreateTrainingTimeSlots < ActiveRecord::Migration
  def change
    create_table :training_time_slots do |t|
      t.integer :training_class_type, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.boolean :monday, default: false, null: false
      t.boolean :tuesday, default: false, null: false
      t.boolean :wednesday, default: false, null: false
      t.boolean :thursday, default: false, null: false
      t.boolean :friday, default: false, null: false
      t.boolean :saturday, default: false, null: false
      t.boolean :sunday, default: false, null: false
      t.integer :person_id, null: false

      t.timestamps null: false
    end
  end
end
