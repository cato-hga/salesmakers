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

  enum status: [
           :pending,
           :started,
           :completed
       ]
end