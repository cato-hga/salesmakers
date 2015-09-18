class AddPhotoUidAndPhotoNameToSprintSale < ActiveRecord::Migration
  def change
    add_column :sprint_sales, :photo_uid, :string
    add_column :sprint_sales, :photo_name, :string
  end
end
