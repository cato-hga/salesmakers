class AddSecondaryIdentifierToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :secondary_identifier, :string
  end
end
