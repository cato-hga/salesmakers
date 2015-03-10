class SeedCandidateDenialReasons < ActiveRecord::Migration
  def change
    CandidateDenialReason.create name: 'Better suited candidate', active: true
    CandidateDenialReason.create name: 'Candidate did not show for interview', active: true
    CandidateDenialReason.create name: 'Candidate not interested in continuing process', active: true
    CandidateDenialReason.create name: 'Previous employee not eligible for rehire', active: true
  end
end
