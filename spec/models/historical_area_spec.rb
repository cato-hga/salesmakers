# == Schema Information
#
# Table name: historical_areas
#
#  id                               :integer          not null, primary key
#  name                             :string           not null
#  area_type_id                     :integer          not null
#  ancestry                         :string
#  project_id                       :integer          not null
#  connect_salesregion_id           :string
#  personality_assessment_url       :string
#  area_candidate_sourcing_group_id :integer
#  email                            :string
#  active                           :boolean          default(TRUE), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  date                             :date             not null
#

require 'rails_helper'

describe HistoricalArea do
end
