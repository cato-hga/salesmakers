# == Schema Information
#
# Table name: areas
#
#  id                               :integer          not null, primary key
#  name                             :string           not null
#  area_type_id                     :integer          not null
#  ancestry                         :string
#  created_at                       :datetime
#  updated_at                       :datetime
#  project_id                       :integer          not null
#  connect_salesregion_id           :string
#  personality_assessment_url       :string
#  area_candidate_sourcing_group_id :integer
#  email                            :string
#  active                           :boolean          default(TRUE), not null
#

require 'rails_helper'

describe HistoricalArea do
end
