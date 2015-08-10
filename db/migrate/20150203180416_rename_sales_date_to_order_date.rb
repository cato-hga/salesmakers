class RenameSalesDateToOrderDate < ActiveRecord::Migration
  def change
    rename_column :comcast_sales, :sale_date, :order_date
  end
end
