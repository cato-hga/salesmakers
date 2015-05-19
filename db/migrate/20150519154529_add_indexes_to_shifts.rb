class AddIndexesToShifts < ActiveRecord::Migration
  def change
    add_index :shifts, :person_id
    add_index :shifts, :location_id
    add_index :shifts, :date
  end
end
