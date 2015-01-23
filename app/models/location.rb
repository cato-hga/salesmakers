class Location < ActiveRecord::Base
  states = Array[ "AK", "AL", "AR", "AS", "AZ", "CA", "CO",
                  "CT", "DC", "DE", "FL", "GA", "GU", "HI",
                  "IA", "ID", "IL", "IN", "KS", "KY", "LA",
                  "MA", "MD", "ME", "MI", "MN", "MO", "MS",
                  "MT", "NC", "ND", "NE", "NH", "NJ", "NM",
                  "NV", "NY", "OH", "OK", "OR", "PA", "PR",
                  "RI", "SC", "SD", "TN", "TX", "UT", "VA",
                  "VI", "VT", "WA", "WI", "WV", "WY" ]

  validates :store_number, presence: true
  validates :city, length: { minimum: 2 }
  validates :state, inclusion: { in: states }
  validates :channel, presence: true

  belongs_to :channel
  has_many :location_areas

  def name(show_channel = true)
    output = ''
    output += self.channel.name + ', ' if show_channel
    output += self.city
    output += ', ' + self.display_name if self.display_name
    output
  end

  def self.return_from_connect_business_partner_location(c_bpl)
    c_loc = c_bpl.connect_location
    return nil unless c_loc
    c_state = c_loc.connect_state
    city = c_bpl.city
    return nil unless city and c_state
    state = c_state.name
    display_name = c_bpl.display_name
    channel = c_bpl.connect_business_partner.get_channel
    return nil unless channel
    store_number = c_bpl.store_number
    return nil unless store_number
    new_location = Location.find_or_create_by display_name: display_name,
                               store_number: store_number,
                               city: city,
                               state: state,
                               channel: channel
    area = c_bpl.area
    if area and new_location
      LocationArea.find_or_create_by location: new_location, area: area
    end
    new_location
  end


end
