class LocationArea < ActiveRecord::Base
  validates :location, presence: true
  validates :area, presence: true, uniqueness: { scope: :location,
                                                 message: 'is already assigned that location' }

  belongs_to :location
  belongs_to :area
  has_and_belongs_to_many :radio_shack_location_schedules
  has_many :candidates


  #default_scope { where(active: true) }

  def self.for_project_and_location(project, location)
    location.location_areas.joins(:area).where("areas.project_id = ?", project.id)
  end
end
