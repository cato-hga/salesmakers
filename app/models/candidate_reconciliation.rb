# == Schema Information
#
# Table name: candidate_reconciliations
#
#  id           :integer          not null, primary key
#  candidate_id :integer          not null
#  status       :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

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
           :nos,
           :needs_work_location,
           :in_training
       ]
end
