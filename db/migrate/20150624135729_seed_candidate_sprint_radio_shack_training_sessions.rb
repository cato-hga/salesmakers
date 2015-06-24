class SeedCandidateSprintRadioShackTrainingSessions < ActiveRecord::Migration
  def up
    candidates = Candidate.where("sprint_radio_shack_training_session_id IS NOT NULL")
    for candidate in candidates do
      CandidateSprintRadioShackTrainingSession.create candidate: candidate,
                                                      sprint_radio_shack_training_session: candidate.sprint_radio_shack_training_session,
                                                      sprint_roster_status: candidate.sprint_roster_status
    end
  end
end
