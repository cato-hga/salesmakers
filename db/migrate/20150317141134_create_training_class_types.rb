class CreateTrainingClassTypes < ActiveRecord::Migration
  def change
    create_table :training_class_types do |t|
      t.integer :project_id, null: false
      t.string :name, null: false
      t.string :ancestry
      t.integer :max_attendance
      t.timestamps null: false
    end
    add_index :training_class_types, :ancestry
  end
end
