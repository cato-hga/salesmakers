class HistoricalLocation < ActiveRecord::Base
  validates :date, presence: true
  validates :store_number, presence: true
  validates :city, length: { minimum: 2 }
  validates :state, inclusion: { in: ::UnitedStates }
  validates :channel, presence: true

  belongs_to :channel
  has_many :historical_location_areas
  has_many :historical_location_client_areas
  belongs_to :sprint_radio_shack_training_location
end
