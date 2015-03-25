class AddSprintRadioShackTrainingLocationData < ActiveRecord::Migration
  def change
    add_column :sprint_radio_shack_training_locations, :virtual, :boolean, null: false, default: true
  end
end
