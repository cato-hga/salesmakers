class RemoveLocationAreaIdFromShift < ActiveRecord::Migration
  def change
    remove_column :shifts, :location_area_id, :string
  end
end
