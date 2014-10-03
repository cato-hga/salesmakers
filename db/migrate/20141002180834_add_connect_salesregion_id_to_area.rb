class AddConnectSalesregionIdToArea < ActiveRecord::Migration
  def change
    add_column :areas, :connect_salesregion_id, :string
  end
end
