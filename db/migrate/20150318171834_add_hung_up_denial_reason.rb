class AddHungUpDenialReason < ActiveRecord::Migration
  def change
    CandidateDenialReason.create name: 'Candidate hung up', active: true
  end
end
