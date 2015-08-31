class AddCreatorIdToVonageSales < ActiveRecord::Migration
  def change
    add_column :vonage_sales, :creator_id, :integer
  end
end
