class RadioShackLocationSchedule < ActiveRecord::Base

  validates :active, presence: true
  validates :name, presence: true
  validates :monday, presence: true
  validates :tuesday, presence: true
  validates :wednesday, presence: true
  validates :thursday, presence: true
  validates :friday, presence: true
  validates :saturday, presence: true
  validates :sunday, presence: true

  has_and_belongs_to_many :location_areas
end
