class RemoveWidthAndHeightFromUploadedImage < ActiveRecord::Migration
  def change
    remove_column :uploaded_images, :width
    remove_column :uploaded_images, :height
  end
end
