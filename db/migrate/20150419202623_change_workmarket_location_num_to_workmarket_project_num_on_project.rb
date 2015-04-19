class ChangeWorkmarketLocationNumToWorkmarketProjectNumOnProject < ActiveRecord::Migration
  def change
    remove_column :projects, :workmarket_location_num
    add_column :projects, :workmarket_project_num, :string
  end
end
