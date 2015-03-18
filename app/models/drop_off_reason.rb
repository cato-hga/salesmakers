class DropOffReason < ActiveRecord::Base

  validates :name, presence: true
  validates :active, presence: true
  validates :eligible_for_reschedule, presence: true
end
