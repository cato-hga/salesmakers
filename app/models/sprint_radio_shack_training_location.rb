class SprintRadioShackTrainingLocation < ActiveRecord::Base
  validates :name, presence: true
  validates :room, presence: true
  validates :virtual, presence: true
end
