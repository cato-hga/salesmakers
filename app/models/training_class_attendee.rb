class TrainingClassAttendee < ActiveRecord::Base

  validates :person_id, presence: true
  validates :training_class_id, presence: true
  validates :attended, presence: true
  validates :status, presence: true
  validates :group_me_setup, presence: true
  validates :time_clock_setup, presence: true

  belongs_to :person
  belongs_to :training_class
end
