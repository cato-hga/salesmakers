class CreateMoreDenialReasons < ActiveRecord::Migration
  def change
    CandidateDenialReason.create name: 'Moved to Vonage consideration', active: true
    CandidateDenialReason.create name: 'Moved to Corporate consideration', active: true
    CandidateDenialReason.create name: 'Moved to Sprint Prepaid consideration', active: true
    CandidateDenialReason.create name: 'Moved to DirectTV consideration', active: true
    CandidateDenialReason.create name: 'Moved to Comcast consideration', active: true
  end
end
