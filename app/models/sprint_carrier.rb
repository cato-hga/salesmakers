# == Schema Information
#
# Table name: sprint_carriers
#
#  id         :integer          not null, primary key
#  name       :string
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SprintCarrier < ActiveRecord::Base

  has_many :sprint_handset
  has_many :sprint_rate_plan

end
