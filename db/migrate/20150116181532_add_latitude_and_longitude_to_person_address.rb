class AddLatitudeAndLongitudeToPersonAddress < ActiveRecord::Migration
  def change
    add_column :person_addresses, :latitude, :float
    add_column :person_addresses, :longitude, :float
  end
end
