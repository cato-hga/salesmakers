class TrainingClass < ActiveRecord::Base

  validates :training_class_type_id, presence: true
  validates :training_time_slot_id, presence: true
  validates :person_id, presence: true
  validates :date, presence: true

  belongs_to :training_class_type
  belongs_to :training_time_slot
  belongs_to :person
end
