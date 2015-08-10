class AddNullFalseToComcastCustomerPersonId < ActiveRecord::Migration
  def change
    change_column :comcast_customers, :person_id, :integer, null: false
  end
end
