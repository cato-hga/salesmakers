# == Schema Information
#
# Table name: sprint_pre_training_welcome_calls
#
#  id                   :integer          not null, primary key
#  still_able_to_attend :boolean          default(FALSE), not null
#  comment              :text
#  group_me_reviewed    :boolean          default(FALSE), not null
#  group_me_confirmed   :boolean          default(FALSE), not null
#  cloud_reviewed       :boolean          default(FALSE), not null
#  cloud_confirmed      :boolean          default(FALSE), not null
#  epay_reviewed        :boolean          default(FALSE), not null
#  epay_confirmed       :boolean          default(FALSE), not null
#  candidate_id         :integer          not null
#  status               :integer          default(0), not null
#

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

  def complete?
    self.group_me_reviewed? and
        self.group_me_confirmed? and
        self.cloud_reviewed and
        self.cloud_confirmed and
        self.epay_reviewed and
        self.epay_confirmed
  end
end
