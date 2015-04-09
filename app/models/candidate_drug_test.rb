class CandidateDrugTest < ActiveRecord::Base

  validates :scheduled, inclusion: {in: [true, false]}
  validates :candidate_id, presence: true

  belongs_to :candidate

  def self.policy_class
    CandidatePolicy
  end
end
