# == Schema Information
#
# Table name: sprint_handsets
#
#  id                :integer          not null, primary key
#  name              :string
#  sprint_carrier_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :sprint_handset do
    name 'LG Volt'
  end

end
