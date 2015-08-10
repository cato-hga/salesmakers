class AddProjectIdToClientAreas < ActiveRecord::Migration
  def change
    add_column :client_areas, :project_id, :integer, null: false
  end
end
