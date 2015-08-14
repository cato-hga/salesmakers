# == Schema Information
#
# Table name: historical_client_areas
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  client_area_type_id :integer          not null
#  ancestry            :string
#  project_id          :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  date                :date             not null
#

require 'rails_helper'

describe HistoricalClientArea do
end
