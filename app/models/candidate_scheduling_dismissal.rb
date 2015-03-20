class CandidateSchedulingDismissal < ActiveRecord::Base

  validates :comment, presence: true
  belongs_to :candidate
  accepts_nested_attributes_for :candidate

  def self.policy_class
    CandidatePolicy
  end
end