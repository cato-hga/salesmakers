class SeedOtherProjectConsiderationDismissalReason < ActiveRecord::Migration
  def change
    CandidateDenialReason.create name: 'Other project consideration', active: true
  end
end
