# == Schema Information
#
# Table name: historical_location_client_areas
#
#  id                        :integer          not null, primary key
#  historical_location_id    :integer          not null
#  historical_client_area_id :integer          not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  date                      :date             not null
#

class HistoricalLocationClientArea < ActiveRecord::Base
  validates :date, presence: true
  validates :historical_location, presence: true
  validates :historical_client_area, presence: true

  belongs_to :historical_location
  belongs_to :historical_client_area
end
