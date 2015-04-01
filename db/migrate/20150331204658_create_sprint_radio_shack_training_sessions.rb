class CreateSprintRadioShackTrainingSessions < ActiveRecord::Migration
  def change
    create_table :sprint_radio_shack_training_sessions do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
