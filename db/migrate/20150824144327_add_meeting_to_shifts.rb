class AddMeetingToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :meeting, :boolean, null: false, default: false
  end
end
