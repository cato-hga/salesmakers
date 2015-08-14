# == Schema Information
#
# Table name: person_areas
#
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  area_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#  manages    :boolean          default(FALSE), not null
#

require 'rails_helper'

describe PersonArea do
end
