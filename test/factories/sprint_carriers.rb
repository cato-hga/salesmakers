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

FactoryGirl.define do
  factory :sprint_carrier do
    name 'Boost Mobile'
  end

end
