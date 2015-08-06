class AddProjectIdAndLocationAreaIdToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :project_id, :integer
    add_column :shifts, :location_area_id, :integer
  end
end
