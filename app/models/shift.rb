class Shift < ActiveRecord::Base
  validates :person, presence: true
  validates :date, presence: true
  validates :hours, presence: true

  belongs_to :person
  belongs_to :location
end