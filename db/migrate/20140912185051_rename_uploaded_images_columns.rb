class RenameUploadedImagesColumns < ActiveRecord::Migration
  def change
    rename_column :uploaded_images, :thumb_url, :thumbnail_uid
    rename_column :uploaded_images, :medium_url, :medium_uid
    rename_column :uploaded_images, :large_url, :large_uid
    rename_column :uploaded_images, :url, :image_uid
  end
end
