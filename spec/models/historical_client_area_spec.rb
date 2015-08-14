# == Schema Information
#
# Table name: client_areas
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  client_area_type_id :integer          not null
#  ancestry            :string
#  created_at          :datetime
#  updated_at          :datetime
#  project_id          :integer          not null
#

require 'rails_helper'

describe HistoricalClientArea do
end
