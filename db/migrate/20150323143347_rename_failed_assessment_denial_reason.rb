class RenameFailedAssessmentDenialReason < ActiveRecord::Migration
  def self.up
    reason = CandidateDenialReason.find_by name: 'Failed personality assessment'
    reason.update name: "Personality assessment score does not qualify for employment"
  end

  def self.down
    reason = CandidateDenialReason.find_by name: "Personality assessment score does not qualify for employment"
    reason.update name: 'Failed personality assessment'
  end
end
