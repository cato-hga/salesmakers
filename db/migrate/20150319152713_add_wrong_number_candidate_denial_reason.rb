class AddWrongNumberCandidateDenialReason < ActiveRecord::Migration
  def change
    CandidateDenialReason.create name: 'Wrong Number', active: true
  end
end
