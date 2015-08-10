# == Schema Information
#
# Table name: candidate_availabilities
#
#  id               :integer          not null, primary key
#  monday_first     :boolean          default(FALSE), not null
#  monday_second    :boolean          default(FALSE), not null
#  monday_third     :boolean          default(FALSE), not null
#  tuesday_first    :boolean          default(FALSE), not null
#  tuesday_second   :boolean          default(FALSE), not null
#  tuesday_third    :boolean          default(FALSE), not null
#  wednesday_first  :boolean          default(FALSE), not null
#  wednesday_second :boolean          default(FALSE), not null
#  wednesday_third  :boolean          default(FALSE), not null
#  thursday_first   :boolean          default(FALSE), not null
#  thursday_second  :boolean          default(FALSE), not null
#  thursday_third   :boolean          default(FALSE), not null
#  friday_first     :boolean          default(FALSE), not null
#  friday_second    :boolean          default(FALSE), not null
#  friday_third     :boolean          default(FALSE), not null
#  saturday_first   :boolean          default(FALSE), not null
#  saturday_second  :boolean          default(FALSE), not null
#  saturday_third   :boolean          default(FALSE), not null
#  sunday_first     :boolean          default(FALSE), not null
#  sunday_second    :boolean          default(FALSE), not null
#  sunday_third     :boolean          default(FALSE), not null
#  candidate_id     :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comment          :text
#

FactoryGirl.define do
  factory :candidate_availability do
    association :candidate
    monday_first true
    tuesday_second true
  end

end
