class CreateTrainingClasses < ActiveRecord::Migration
  def change
    create_table :training_classes do |t|
      t.integer :training_class_type_id
      t.integer :training_time_slot_id
      t.datetime :date
      t.integer :person_id

      t.timestamps null: false
    end
  end
end
