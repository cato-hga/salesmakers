class TrainingUnavailabilityReason < ActiveRecord::Base
  validates :name, presence: true

  has_many :training_availabilities

  default_scope { order :name }
end
