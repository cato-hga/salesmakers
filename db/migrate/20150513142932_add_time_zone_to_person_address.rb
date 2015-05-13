class AddTimeZoneToPersonAddress < ActiveRecord::Migration
  def change
    add_column :person_addresses, :time_zone, :string
  end
end
