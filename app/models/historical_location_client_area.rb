class HistoricalLocationClientArea < ActiveRecord::Base
  validates :date, presence: true
  validates :historical_location, presence: true
  validates :historical_client_area, presence: true, uniqueness: { scope: :historical_location,
                                                                   message: 'is already assigned that location' }

  belongs_to :historical_location
  belongs_to :historical_client_area
end
