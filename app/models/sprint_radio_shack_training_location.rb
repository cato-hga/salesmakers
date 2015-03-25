class SprintRadioShackTrainingLocation < ActiveRecord::Base
  geocoded_by :address
  validates :name, presence: true
  validates :room, presence: true
  validates :virtual, presence: true

  private

  def geocode_on_production
    return unless Rails.env.production?
    self.geocode
    sleep 0.21
  end
end
