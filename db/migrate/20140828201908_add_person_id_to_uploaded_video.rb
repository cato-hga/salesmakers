class AddPersonIdToUploadedVideo < ActiveRecord::Migration
  def change
    add_column :uploaded_videos, :person_id, :integer, null: false
  end
end
