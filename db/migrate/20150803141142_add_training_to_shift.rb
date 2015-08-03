class AddTrainingToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :training, :boolean, null: false, default: false
  end
end
