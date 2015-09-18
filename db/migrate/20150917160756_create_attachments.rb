class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :name, null: false
      t.integer :attachable_id, null: false
      t.string :attachable_type, null: false
      t.string :attachment_uid
      t.string :attachment_name

      t.timestamps null: false
    end
  end
end
