class CreateSprintRosterStatus < ActiveRecord::Migration
  def change
    add_column :candidates, :sprint_roster_status, :integer
  end
end
