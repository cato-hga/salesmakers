class MoveSprintConfirmedForSprintSubmitted < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute %{
      UPDATE candidates SET sprint_roster_status = 2 WHERE sprint_roster_status = 1
    }
  end

  def self.down
    ActiveRecord::Base.connection.execute %{
      UPDATE candidates SET sprint_roster_status = 1 WHERE sprint_roster_status = 2
    }
  end
end
