class AddLocationIdToDirecTVCustomer < ActiveRecord::Migration
  def change
    add_column :directv_customers, :location_id, :integer
  end
end
