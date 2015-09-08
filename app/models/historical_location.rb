# == Schema Information
#
# Table name: historical_locations
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
#  latitude                                :float
#  longitude                               :float
#  sprint_radio_shack_training_location_id :integer
#  cost_center                             :string
#  mail_stop                               :string
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  date                                    :date             not null
#

class HistoricalLocation < ActiveRecord::Base
  validates :date, presence: true
  validates :store_number, presence: true
  validates :city, length: { minimum: 2 }
  validates :state, inclusion: { in: ::UnitedStates }
  validates :channel, presence: true

  belongs_to :channel
  has_many :historical_location_areas
  has_many :historical_location_client_areas
  belongs_to :sprint_radio_shack_training_location
end
