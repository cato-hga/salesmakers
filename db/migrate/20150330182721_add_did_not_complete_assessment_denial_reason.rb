class AddDidNotCompleteAssessmentDenialReason < ActiveRecord::Migration
  def change
    CandidateDenialReason.create name: 'Did not complete personality assessment', active: true
  end
end
