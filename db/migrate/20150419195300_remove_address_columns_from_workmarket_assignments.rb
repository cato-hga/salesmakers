class RemoveAddressColumnsFromWorkmarketAssignments < ActiveRecord::Migration
  def change
    remove_column :workmarket_assignments, :street_1, :string
    remove_column :workmarket_assignments, :street_2, :string
    remove_column :workmarket_assignments, :city, :string
    remove_column :workmarket_assignments, :state, :string
    remove_column :workmarket_assignments, :zip, :string
    add_column :workmarket_assignments, :workmarket_location_num, :string, null: false
  end
end
