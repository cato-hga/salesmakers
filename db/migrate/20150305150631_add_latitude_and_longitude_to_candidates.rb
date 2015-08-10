class AddLatitudeAndLongitudeToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :latitude, :float
    add_column :candidates, :longitude, :float
  end
end
