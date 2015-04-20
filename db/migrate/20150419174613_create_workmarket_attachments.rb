class CreateWorkmarketAttachments < ActiveRecord::Migration
  def change
    create_table :workmarket_attachments do |t|
      t.integer :workmarket_assignment_id, null: false
      t.string :filename, null: false
      t.string :url, null: false

      t.timestamps null: false
    end
  end
end
