class RenameMediumUidToPreviewUidOnUploadedImage < ActiveRecord::Migration
  def change
    rename_column :uploaded_images, :medium_uid, :preview_uid
  end
end
