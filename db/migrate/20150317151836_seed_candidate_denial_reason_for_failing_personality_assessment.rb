class SeedCandidateDenialReasonForFailingPersonalityAssessment < ActiveRecord::Migration
  def change
    CandidateDenialReason.create name: 'Failed personality assessment', active: true
  end
end
