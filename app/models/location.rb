class Location < ActiveRecord::Base
  states = Array["AK", "AL", "AR", "AS", "AZ", "CA", "CO",
                 "CT", "DC", "DE", "FL", "GA", "GU", "HI",
                 "IA", "ID", "IL", "IN", "KS", "KY", "LA",
                 "MA", "MD", "ME", "MI", "MN", "MO", "MS",
                 "MT", "NC", "ND", "NE", "NH", "NJ", "NM",
                 "NV", "NY", "OH", "OK", "OR", "PA", "PR",
                 "RI", "SC", "SD", "TN", "TX", "UT", "VA",
                 "VI", "VT", "WA", "WI", "WV", "WY"]

  validates :store_number, presence: true
  validates :city, length: { minimum: 2 }
  validates :state, inclusion: { in: states }
  validates :channel, presence: true

  belongs_to :channel
  has_many :location_areas
  has_many :comcast_customers

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
    new_location = Location.find_or_initialize_by store_number: store_number,
                                                  channel: channel
    new_location.display_name = display_name
    new_location.city = city
    new_location.state = state
    is_new = new_location.new_record?
    return unless new_location.save
    if is_new
      c_creator = ConnectUser.find_by ad_user_id: c_bpl.createdby
      creator = Person.return_from_connect_user c_creator
      if creator
        creator.log? 'create',
                     new_location,
                     nil,
                     c_bpl.created,
                     c_bpl.created
      end
    end
    area = c_bpl.area
    if area
      location_area = LocationArea.find_or_initialize_by location: new_location,
                                                         area: area
      is_new = location_area.new_record?
      if location_area.save and is_new
        c_creator = ConnectUser.find_by ad_user_id: c_bpl.createdby
        creator = Person.return_from_connect_user c_creator
        if creator
          creator.log? 'create',
                       location_area,
                       nil,
                       c_bpl.created,
                       c_bpl.created
        end
      end
    end
    new_location
  end

  def self.update_from_connect(minutes)
    offset = Time.zone_offset(Time.zone.now.strftime('%Z')) / 60
    offset = offset * -1
    num_minutes = minutes + offset
    c_bpls = ConnectBusinessPartnerLocation.where('updated >= ?', (Time.now - num_minutes.minutes).apply_eastern_offset)
    for c_bpl in c_bpls do
      location = Location.return_from_connect_business_partner_location(c_bpl)
      next unless location
      if c_bpl.isactive == 'N'
        area = c_bpl.area
        next unless area
        for location_area in location.location_areas.where(area: area) do
          location_area.destroy
          c_updater = ConnectUser.find_by ad_user_id: c_bpl.updatedby
          updater = Person.return_from_connect_user c_updater
          if updater
            updater.log? 'unassign',
                         location,
                         area,
                         c_bpl.updated.apply_eastern_offset,
                         c_bpl.updated.apply_eastern_offset
          end
        end
      end
    end
  end

end
