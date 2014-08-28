class CreateUploadedImages < ActiveRecord::Migration
  def change
    create_table :uploaded_images do |t|
      t.string :url, null: false
      t.string :thumb_url, null: false
      t.string :medium_url, null: false
      t.string :large_url, null: false
      t.integer :person_id, null: false
      t.string :caption
      t.integer :width, null: false
      t.integer :height, null: false

      t.timestamps
    end
  end
end
