class CandidateDenialReason < ActiveRecord::Base

  validates :name, presence: true
  validates :active, presence: true

end
