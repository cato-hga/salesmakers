class AddCandidateInactiveDenialReason < ActiveRecord::Migration
  def change
    CandidateDenialReason.create name: 'Candidate inactive for over 7 days', active: true
  end
end
