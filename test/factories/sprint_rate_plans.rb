# == Schema Information
#
# Table name: sprint_rate_plans
#
#  id                :integer          not null, primary key
#  name              :string
#  sprint_carrier_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :sprint_rate_plan do
    name '$55/Monthly'
  end

end
