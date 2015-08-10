class ChangeFieldsOnSprintSales < ActiveRecord::Migration
  def change
    change_column :sprint_sales, :mobile_phone, :string, null: true
    change_column :sprint_sales, :picture_with_customer, :string, null: true
  end
end
