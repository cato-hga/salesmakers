class AddProjectIdToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :project_id, :integer, null: false
  end
end
