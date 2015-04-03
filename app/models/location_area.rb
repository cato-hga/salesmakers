class LocationArea < ActiveRecord::Base
  validates :location, presence: true
  validates :area, presence: true, uniqueness: {scope: :location,
                                                message: 'is already assigned that location'}

  belongs_to :location
  belongs_to :area
  has_and_belongs_to_many :radio_shack_location_schedules
  has_many :candidates


  #default_scope { where(active: true) }

  def self.for_project_and_location(project, location)
    location.location_areas.joins(:area).where("areas.project_id = ?", project.id)
  end

  def head_count_full?
    return true if (self.target_head_count - (self.offer_extended_count + self.current_head_count)) <= -1
    false
  end

  def self.get_all_location_areas(candidate, current_person)
    all_locations = Location.
        joins(:location_areas).
        where('location_areas.target_head_count > 0')
    return LocationArea.none if all_locations.count(:all) < 1
    all_locations = Location.where("locations.id IN (#{all_locations.map(&:id).join(',')})")
    locations = all_locations.near(candidate, 30)
    if not locations or locations.count(:all) < 5
      locations = all_locations.near(candidate, 500).first(5)
    end
    return LocationArea.none if locations.empty?
    location_areas = locations.map { |l| l.location_areas }.flatten
    LocationAreaPolicy::Scope.new(current_person, LocationArea.where("location_areas.id IN (#{location_areas.map(&:id).join(',')}) AND active = true")).resolve
  end
end
