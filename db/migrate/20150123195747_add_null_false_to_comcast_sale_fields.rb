class AddNullFalseToComcastSaleFields < ActiveRecord::Migration
  def change
    change_column :comcast_sales, :sale_date, :datetime, null: false
    change_column :comcast_sales, :person_id, :integer, null: false
    change_column :comcast_sales, :comcast_customer_id, :integer, null: false
    change_column :comcast_sales, :order_number, :string, null: false
    change_column :comcast_sales, :tv, :boolean, null: false, default: false
    change_column :comcast_sales, :internet, :boolean, null: false, default: false
    change_column :comcast_sales, :phone, :boolean, null: false, default: false
    change_column :comcast_sales, :security, :boolean, null: false, default: false
    change_column :comcast_sales, :customer_acknowledged, :boolean, null: false, default: false
  end
end
