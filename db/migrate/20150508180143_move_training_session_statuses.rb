class MoveTrainingSessionStatuses < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute(
        %{
          update candidates
          set
          training_session_status = training_session_status - 1
          where
            training_session_status > 2
        }
    )
  end
end
