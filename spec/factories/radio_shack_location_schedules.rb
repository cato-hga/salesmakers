# == Schema Information
#
# Table name: radio_shack_location_schedules
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  monday     :float            default(0.0), not null
#  tuesday    :float            default(0.0), not null
#  wednesday  :float            default(0.0), not null
#  thursday   :float            default(0.0), not null
#  friday     :float            default(0.0), not null
#  saturday   :float            default(0.0), not null
#  sunday     :float            default(0.0), not null
#

FactoryGirl.define do
  factory :radio_shack_location_schedule do
    name 'A1PT1'
    tuesday 4
    wednesday 8
    friday 4
    saturday 4
  end

end
