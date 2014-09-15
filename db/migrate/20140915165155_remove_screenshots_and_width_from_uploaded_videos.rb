class RemoveScreenshotsAndWidthFromUploadedVideos < ActiveRecord::Migration
  def change
    remove_column :uploaded_videos, :screenshot_url
    remove_column :uploaded_videos, :screenshot_thumb_url
    remove_column :uploaded_videos, :screenshot_medium_url
    remove_column :uploaded_videos, :screenshot_large_url
    remove_column :uploaded_videos, :screenshot_caption
    remove_column :uploaded_videos, :width
    remove_column :uploaded_videos, :height
    remove_column :uploaded_videos, :description
  end
end
