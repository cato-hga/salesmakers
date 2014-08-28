class CreateUploadedVideos < ActiveRecord::Migration
  def change
    create_table :uploaded_videos do |t|
      t.string :url, null: false
      t.string :screenshot_url, null: false
      t.string :screenshot_thumb_url, null: false
      t.string :screenshot_medium_url, null: false
      t.string :screenshot_large_url, null: false
      t.string :screenshot_caption
      t.text :description
      t.integer :width, null: false
      t.integer :height, null: false

      t.timestamps
    end
  end
end
