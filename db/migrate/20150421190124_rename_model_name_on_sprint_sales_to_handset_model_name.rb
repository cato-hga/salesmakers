class RenameModelNameOnSprintSalesToHandsetModelName < ActiveRecord::Migration
  def change
    rename_column :sprint_sales, :model_name, :handset_model_name
  end
end
