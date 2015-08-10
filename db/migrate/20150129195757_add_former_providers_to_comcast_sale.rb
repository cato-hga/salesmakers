class AddFormerProvidersToComcastSale < ActiveRecord::Migration
  def change
    add_column :comcast_sales, :comcast_former_provider_id, :integer
  end
end