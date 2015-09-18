class AddPersonIdToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :person_id, :integer, null: false
  end
end
