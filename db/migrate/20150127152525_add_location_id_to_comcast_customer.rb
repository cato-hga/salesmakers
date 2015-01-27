class AddLocationIdToComcastCustomer < ActiveRecord::Migration
  def change
    add_column :comcast_customers, :location_id, :integer, null: false
  end
end
