class AddWorkmarketLocationNumToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :workmarket_location_num, :string
  end
end
