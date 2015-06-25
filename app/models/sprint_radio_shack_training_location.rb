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

class SprintRadioShackTrainingLocation < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode_on_production,
                   if: ->(location) {
                     location.address and location.address_changed? and not location.virtual?
                   }
  validates :name, presence: true
  validates :room, presence: true
  validates :virtual, inclusion: {in: [true, false]}

  def geographic_distance(coordinates)
    Geocoder::Calculations.distance_between self, coordinates
  end

  private

  def geocode_on_production
    return unless Rails.env.production?
    self.geocode
    sleep 0.21
  end
end
