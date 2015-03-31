class CandidateLocation
  attr_accessor :street_1,
                :street_2,
                :city,
                :state,
                :zip,
                :store_number,
                :display_name,
                :latitude,
                :longitude,
                :channel_name,
                :project_name,
                :mail_to

  def initialize(location_area)
    location = location_area.location
    self.street_1 = location.street_1
    self.street_2 = location.street_2
    self.city = location.city
    self.state = location.state
    self.zip = location.zip
    self.store_number = location.store_number
    self.display_name = location.display_name
    self.latitude = location.latitude
    self.longitude = location.longitude
    self.channel_name = location.channel.name
    self.project_name = location_area.area.project.name
    self.mail_to = 'not_yet@available.com'
  end
end