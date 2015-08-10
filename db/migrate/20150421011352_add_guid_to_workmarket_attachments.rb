class AddGuidToWorkmarketAttachments < ActiveRecord::Migration
  def self.up
    WorkmarketAttachment.destroy_all
    WorkmarketField.destroy_all
    WorkmarketAssignment.destroy_all
    add_column :workmarket_attachments, :guid, :string, null: false
  end

  def self.down
    remove_column :workmarket_attachments, :guid
  end
end
