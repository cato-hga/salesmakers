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
