class AvailabilityValidator < ActiveModel::Validator
  def validate(record)
    unless record.monday_first or
        record.monday_second or
        record.monday_third or
        record.tuesday_first or
        record.tuesday_second or
        record.tuesday_third or
        record.wednesday_first or
        record.wednesday_second or
        record.wednesday_third or
        record.thursday_first or
        record.thursday_second or
        record.thursday_third or
        record.friday_first or
        record.friday_second or
        record.friday_third or
        record.saturday_first or
        record.saturday_second or
        record.saturday_third or
        record.sunday_first or
        record.sunday_second or
        record.sunday_third
      record.errors[:schedule] << 'At least one schedule period must be selected'
      return
    end
  end

  def self.policy_class
    CandidatePolicy
  end
end

class CandidateAvailability < ActiveRecord::Base

  validates :candidate_id, presence: true
  validates_with AvailabilityValidator
  belongs_to :candidate


end
