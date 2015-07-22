# == Schema Information
#
# Table name: location_client_areas
#
#  id             :integer          not null, primary key
#  location_id    :integer          not null
#  client_area_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class LocationClientArea < ActiveRecord::Base
  validates :location, presence: true
  validates :client_area, presence: true, uniqueness: { scope: :location,
                                                 message: 'is already assigned that location' }

  belongs_to :location
  belongs_to :client_area

  has_paper_trail

  default_scope {
    joins(:client_area).joins(:location).order("client_areas.name, locations.display_name")
  }

  def self.for_project_and_location(project, location)
    location.location_client_areas.joins(:client_area).where("client_areas.project_id = ?", project.id)
  end
end
