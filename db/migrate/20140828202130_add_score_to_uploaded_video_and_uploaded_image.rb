class AddScoreToUploadedVideoAndUploadedImage < ActiveRecord::Migration
  def change
    add_column :uploaded_videos, :score, :integer, null: false, default: 0
    add_column :uploaded_images, :score, :integer, null: false, default: 0
  end
end
