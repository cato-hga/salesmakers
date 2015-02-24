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
  has_many :comcast_eods

  def name(show_channel = true)
    output = ''
    output += self.channel.name + ', ' if show_channel
    output += self.city
    output += ', ' + self.display_name if self.display_name
    output
  end

  def self.return_from_connect_business_partner_location(c_bpl)
    location_hash = get_location_hash(c_bpl) || return
    new_location = Location.find_or_initialize_by store_number: location_hash[:store_number],
                                                  channel: location_hash[:channel]
    new_location.attributes = {
        display_name: location_hash[:display_name],
        city: location_hash[:city],
        state: location_hash[:state]
    }
    return unless new_location.save
    log_creation(new_location, c_bpl)
    create_location_area(new_location, c_bpl)
  end

  def self.get_location_hash(c_bpl)
    location_hash = { }
    location_hash[:c_loc] = c_bpl.connect_location || return
    location_hash[:c_state] = location_hash[:c_loc].connect_state || return
    location_hash[:city] = c_bpl.city || return
    location_hash[:state] = location_hash[:c_state].name
    location_hash[:display_name] = c_bpl.display_name
    location_hash[:channel] = c_bpl.connect_business_partner.get_channel || return
    location_hash[:store_number] = c_bpl.store_number || return
    location_hash
  end

  def self.log_creation(new_location, c_bpl)
    is_new = new_location.new_record?
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
  end

  def self.create_location_area(new_location, c_bpl)
    area = c_bpl.area
    if area
      location_area = LocationArea.find_or_initialize_by location: new_location,
                                                         area: area
      is_new = location_area.new_record?
      if location_area.save and is_new
        log_location_area_creation(location_area, c_bpl)
      end
    end
    new_location
  end

  def self.log_location_area_creation(location_area, c_bpl)
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

  def self.update_from_connect(minutes)
    offset = Time.zone_offset(Time.zone.now.strftime('%Z')) / 60
    offset = offset * -1
    num_minutes = minutes + offset
    c_bpls = ConnectBusinessPartnerLocation.where('updated >= ?', (Time.now - num_minutes.minutes).apply_eastern_offset)
    c_bpls.each { |c_bpl| update_individual_from_connect(c_bpl) }
  end

  def self.update_individual_from_connect(c_bpl)
    location = Location.return_from_connect_business_partner_location(c_bpl) || return
    if c_bpl.isactive == 'N'
      area = c_bpl.area || return
      for location_area in location.location_areas.where(area: area) do
        location_area.destroy
        log_unassign(location, area, c_bpl)
      end
    end
  end

  def self.log_unassign(location, area, c_bpl)
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
