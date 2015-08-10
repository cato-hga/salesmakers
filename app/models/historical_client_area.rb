class HistoricalClientArea < ActiveRecord::Base
  validates :date, presence: true
  validates :name, presence: true, length: { minimum: 3 }
  validates :client_area_type, presence: true

  belongs_to :client_area_type
  belongs_to :project
end
