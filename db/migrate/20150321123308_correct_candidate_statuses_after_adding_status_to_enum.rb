class CorrectCandidateStatusesAfterAddingStatusToEnum < ActiveRecord::Migration
  def self.up
    candidates = Candidate.where "status > 6"
    ActiveRecord::Base.record_timestamps = false
    for candidate in candidates do
      candidate.update status: Candidate.statuses[candidate.status] + 1
    end
    ActiveRecord::Base.record_timestamps = true
  end

  def self.down
    candidates = Candidate.where "status > 7"
    ActiveRecord::Base.record_timestamps = false
    for candidate in candidates do
      candidate.update status: Candidate.statuses[candidate.status] - 1
    end
    ActiveRecord::Base.record_timestamps = true
  end
end
