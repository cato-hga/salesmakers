class CandidateLocation
  attr_accessor :street_1,
                :street_2,
                :city,
                :state,
                :zip,
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
    self.latitude = location.latitude
    self.longitude = location.longitude
    self.channel_name = location.channel.name
    self.project_name = location_area.area.project.name
    self.mail_to = 'not_yet@available.com'
  end
end