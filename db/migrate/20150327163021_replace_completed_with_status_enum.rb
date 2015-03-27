class ReplaceCompletedWithStatusEnum < ActiveRecord::Migration
  def change
    remove_column :sprint_pre_training_welcome_calls, :completed
    add_column :sprint_pre_training_welcome_calls, :status, :integer, default: 0, null: false
  end
end