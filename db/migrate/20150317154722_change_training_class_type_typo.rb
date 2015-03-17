class ChangeTrainingClassTypeTypo < ActiveRecord::Migration
  def change
    rename_column :training_time_slots, :training_class_type, :training_class_type_id
  end
end
