class ChangeNotNullStatusOnMeidForSprintSale < ActiveRecord::Migration
  def change
    change_column :sprint_sales, :meid, :string, null: true
  end
end
