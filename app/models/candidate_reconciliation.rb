class CandidateReconciliation < ActiveRecord::Base

  validates :candidate_id, presence: true
  validates :status, presence: true

  belongs_to :candidate

  enum status: [
           :not_contacted,
           :contacted_awaiting_response,
           :ready_for_training_location_available,
           :ready_for_training_location_full,
           :working,
           :nos
       ]
end
