class SeedCandidateDenialReasonForFailingScreening < ActiveRecord::Migration
  def change
    CandidateDenialReason.create name: 'Did not pass employment screening', active: true
  end
end
