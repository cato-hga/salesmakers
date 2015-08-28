class AddNumberOfAccessoriesToSprintSale < ActiveRecord::Migration
  def change
    add_column :sprint_sales, :number_of_accessories, :integer
  end
end
