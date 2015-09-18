# == Schema Information
#
# Table name: historical_location_areas
#
#  id                        :integer          not null, primary key
#  historical_location_id    :integer          not null
#  historical_area_id        :integer          not null
#  current_head_count        :integer          default(0), not null
#  potential_candidate_count :integer          default(0), not null
#  target_head_count         :integer          default(0), not null
#  active                    :boolean          default(TRUE), not null
#  hourly_rate               :float
#  offer_extended_count      :integer          default(1), not null
#  outsourced                :boolean
#  launch_group              :integer
#  distance_to_cor           :float
#  priority                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  date                      :date             not null
#  bilingual                 :boolean          default(FALSE)
#

class HistoricalLocationArea < ActiveRecord::Base
  validates :date, presence: true
  validates :historical_location, presence: true
  validates :historical_area, presence: true

  belongs_to :historical_location
  belongs_to :historical_area
end
