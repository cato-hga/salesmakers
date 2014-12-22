class RemoveSecondIdentifierFromDevices < ActiveRecord::Migration
  def change
    remove_column :devices, :secondary_identifier
  end
end
