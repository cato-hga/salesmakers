class SprintRadioShackTrainingLocation < ActiveRecord::Base
  validates :address, presence: true
  validates :name, presence: true
  validates :room, presence: true
end
