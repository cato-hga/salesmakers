class SprintPreTrainingWelcomeCall < ActiveRecord::Base

  validates :candidate_id, presence: true
  validates :cloud_confirmed, inclusion: {in: [true, false]}
  validates :cloud_reviewed, inclusion: {in: [true, false]}
  validates :group_me_confirmed, inclusion: {in: [true, false]}
  validates :group_me_reviewed, inclusion: {in: [true, false]}
  validates :epay_confirmed, inclusion: {in: [true, false]}
  validates :epay_reviewed, inclusion: {in: [true, false]}
  validates :still_able_to_attend, inclusion: {in: [true, false]}

  belongs_to :candidate
  has_one :training_availability, through: :candidate
  accepts_nested_attributes_for :candidate

  enum status: [
           :pending,
           :started,
           :completed
       ]

  def self.policy_class
    CandidatePolicy
  end
end