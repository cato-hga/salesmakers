class RemoveAmPmfromTrainingAvailability < ActiveRecord::Migration
  def change
    remove_column :training_availabilities, :monday_am, :boolean
    remove_column :training_availabilities, :monday_pm, :boolean
    remove_column :training_availabilities, :tuesday_am, :boolean
    remove_column :training_availabilities, :tuesday_pm, :boolean
    remove_column :training_availabilities, :wednesday_am, :boolean
    remove_column :training_availabilities, :wednesday_pm, :boolean
    remove_column :training_availabilities, :thursday_am, :boolean
    remove_column :training_availabilities, :thursday_pm, :boolean
    remove_column :training_availabilities, :friday_am, :boolean
    remove_column :training_availabilities, :friday_pm, :boolean
    remove_column :training_availabilities, :saturday_am, :boolean
    remove_column :training_availabilities, :saturday_pm, :boolean
    remove_column :training_availabilities, :sunday_am, :boolean
    remove_column :training_availabilities, :sunday_pm, :boolean
  end
end