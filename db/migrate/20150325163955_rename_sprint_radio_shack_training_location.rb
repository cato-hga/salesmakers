class RenameSprintRadioShackTrainingLocation < ActiveRecord::Migration
  def change
    rename_column :locations, :sprint_radio_shack_location_id, :sprint_radio_shack_training_location_id
  end
end
