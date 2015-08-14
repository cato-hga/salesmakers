# == Schema Information
#
# Table name: historical_person_client_areas
#
#  id                        :integer          not null, primary key
#  historical_person_id      :integer          not null
#  historical_client_area_id :integer          not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  date                      :date             not null
#

require 'rails_helper'

describe HistoricalPersonClientArea do
end
