# == Schema Information
#
# Table name: locations
#
#  id                                      :integer          not null, primary key
#  display_name                            :string
#  store_number                            :string           not null
#  street_1                                :string
#  street_2                                :string
#  city                                    :string           not null
#  state                                   :string           not null
#  zip                                     :string
#  channel_id                              :integer          not null
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  latitude                                :float
#  longitude                               :float
#  sprint_radio_shack_training_location_id :integer
#  cost_center                             :string
#  mail_stop                               :string
#

FactoryGirl.define do

  factory :location do
    display_name '34th St N'
    store_number 'CCWM4690'
    city 'St. Petersburg'
    state 'FL'
    street_1 '555 34th St N'
    channel
  end

end
