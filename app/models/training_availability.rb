# == Schema Information
#
# Table name: training_availabilities
#
#  id                                :integer          not null, primary key
#  able_to_attend                    :boolean          default(FALSE), not null
#  training_unavailability_reason_id :integer
#  comments                          :text
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  candidate_id                      :integer          not null
#

class TrainingAvailability < ActiveRecord::Base
  validates :able_to_attend, inclusion: { in: [true, false] }
  validates :candidate, presence: true
  validate :unavailable_fields

  belongs_to :training_unavailability_reason
  belongs_to :candidate
  accepts_nested_attributes_for :candidate

  def self.policy_class
    CandidatePolicy
  end

  private

  def unavailable_fields
    return if able_to_attend?
    validate_reason_present
  end

  def validate_reason_present
    unless self.training_unavailability_reason
      errors.add :training_unavailability_reason,
                 'must be present when candidate is unable to attend training'
    end
  end
end
