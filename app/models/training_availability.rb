class TrainingAvailability < ActiveRecord::Base
  validates :able_to_attend, inclusion: { in: [true, false] }
  validates :candidate, presence: true
  validate :unavailable_fields

  belongs_to :training_unavailability_reason
  belongs_to :candidate

  private

  def unavailable_fields
    return if able_to_attend?
    validate_reason_present
    validate_at_least_one_availability
  end

  def validate_reason_present
    unless self.training_unavailability_reason
      errors.add :training_unavailability_reason,
                 'must be present when candidate is unable to attend training'
    end
  end

  def validate_at_least_one_availability
    unless one_availability?
      errors.add :training_unavailability_reason,
                 'must be accompanied by at least one AM/PM availability'
    end
  end

  def one_availability?
    monday_am? ||
        monday_pm? ||
        tuesday_am? ||
        tuesday_pm? ||
        wednesday_am? ||
        wednesday_pm? ||
        thursday_am? ||
        thursday_pm? ||
        friday_am? ||
        friday_pm? ||
        saturday_am? ||
        saturday_pm? ||
        sunday_am? ||
        sunday_pm?
  end
end
