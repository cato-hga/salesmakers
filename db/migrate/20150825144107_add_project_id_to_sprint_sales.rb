class AddProjectIdToSprintSales < ActiveRecord::Migration
  def change
    add_column :sprint_sales, :project_id, :integer
  end
end
