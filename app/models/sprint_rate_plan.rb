# == Schema Information
#
# Table name: sprint_rate_plans
#
#  id         :integer          not null, primary key
#  name       :string
#  carrier_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SprintRatePlan < ActiveRecord::Base

  belongs_to :sprint_carrier

end
