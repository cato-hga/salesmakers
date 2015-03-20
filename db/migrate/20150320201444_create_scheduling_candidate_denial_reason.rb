class CreateSchedulingCandidateDenialReason < ActiveRecord::Migration
  def change
    CandidateDenialReason.create name: 'Scheduling Conflict', active: true
  end
end
