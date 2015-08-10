class MoveTrainingSessionStatusForShadowConfirmed < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute %{
      UPDATE candidates SET training_session_status = training_session_status + 1 WHERE training_session_status >= 2
    }
  end

  def self.down
    ActiveRecord::Base.connection.execute %{
      UPDATE candidates SET training_session_status = training_session_status - 1 WHERE training_session_status >= 3
    }
  end
end
