class HistoricalPersonArea < ActiveRecord::Base
  validates :date, presence: true
  validates :historical_person, presence: true
  validates :historical_area, presence: true

  belongs_to :historical_person
  belongs_to :historical_area

  delegate :project, to: :historical_area
  delegate :client, to: :historical_area
end
