class AddLockedToSprintRadioShackTrainingSession < ActiveRecord::Migration
  def change
    add_column :sprint_radio_shack_training_sessions, :locked, :boolean, null: false, default: false
  end
end
