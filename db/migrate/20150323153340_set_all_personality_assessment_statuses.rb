class SetAllPersonalityAssessmentStatuses < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.record_timestamps = false
    for candidate in Candidate.all do
      failed_log_entries = LogEntry.for_candidate(candidate).where(action: 'failed_assessment')
      if failed_log_entries.empty? and candidate.passed_personality_assessment?
        candidate.update personality_assessment_status: :qualified
      elsif candidate.passed_personality_assessment? and not failed_log_entries.empty?
        candidate.update personality_assessment_status: :disqualified
      else
        candidate.update personality_assessment_status: :incomplete
      end
    end
    ActiveRecord::Base.record_timestamps = true
  end
end
