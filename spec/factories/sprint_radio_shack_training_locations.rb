# == Schema Information
#
# Table name: sprint_radio_shack_training_locations
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  address    :string           not null
#  room       :string           not null
#  latitude   :float
#  longitude  :float
#  virtual    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :sprint_radio_shack_training_location do
    name 'Rutherford'
    address '201 Rte. 17 North, Rutherford NJ 07070'
    room '302'
  end

end
