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

require 'rails_helper'

describe HistoricalLocationArea do
  subject { build :historical_location_area }
end
