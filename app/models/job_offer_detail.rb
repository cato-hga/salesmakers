class JobOfferDetail < ActiveRecord::Base

  validates :candidate_id, presence: true
  validates :sent, presence: true

  belongs_to :candidate
end
