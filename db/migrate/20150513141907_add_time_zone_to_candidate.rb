class AddTimeZoneToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :time_zone, :string
  end
end
