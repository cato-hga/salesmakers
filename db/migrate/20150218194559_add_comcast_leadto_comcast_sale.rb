class AddComcastLeadtoComcastSale < ActiveRecord::Migration
  def change
    add_column :comcast_sales, :comcast_lead_id, :integer
  end
end
