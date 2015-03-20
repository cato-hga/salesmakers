class SeedNotEnoughtTechnologyDismissalReason < ActiveRecord::Migration
  def change
    CandidateDenialReason.create name: 'Not enough technology', active: true
  end
end
