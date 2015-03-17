require 'validators/training_time_slot_validator'
class TrainingTimeSlot < ActiveRecord::Base

  validates :training_class_type_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :person_id, presence: true
  validates_with TrainingTimeSlotValidator

  belongs_to :training_class_type
  belongs_to :person

end


