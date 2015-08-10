class HistoricalPersonClientArea < ActiveRecord::Base
  validates :date, presence: true
  validates :historical_person, presence: true
  validates :historical_client_area, presence: true

  belongs_to :historical_person
  belongs_to :historical_client_area

  delegate :project, to: :historical_client_area
  delegate :client, to: :historical_client_area
end
