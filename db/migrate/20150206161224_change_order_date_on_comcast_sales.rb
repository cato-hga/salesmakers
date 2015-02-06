class ChangeOrderDateOnComcastSales < ActiveRecord::Migration
  def change
    change_column :comcast_sales, :order_date, :date
  end
end
