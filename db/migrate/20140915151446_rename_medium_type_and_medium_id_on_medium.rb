class RenameMediumTypeAndMediumIdOnMedium < ActiveRecord::Migration
  def change
    rename_column :media, :medium_type, :mediable_type
    rename_column :media, :medium_id, :mediable_id
  end
end
