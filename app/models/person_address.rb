class PersonAddress < ActiveRecord::Base
  geocoded_by :address
  nilify_blanks

  validates :person, presence: true
  validates :line_1, format: { with: /\A\d+(\-)?[A-Za-z]? .{2,}\z/, message: 'must be a valid street address' }
  validates :city, length: { minimum: 2 }
  validates :state, length: { is: 2 }, inclusion: { in: ::UnitedStates }
  validates :zip, format: { with: /\A\d{5}\z/, message: 'must be 5 digits' }

  belongs_to :person

  def state=(value)
    unless value
      self[:state] = value
      return
    end
    self[:state] = value.upcase
  end

  def address
    string_address = ''
    string_address += self.line_1 if self.line_1
    string_address += ', '
    string_address += self.line_2 + ', ' unless self.line_2.blank?
    string_address += self.city + ', ' if self.city
    string_address += self.state if self.state
    string_address += ' ' + self.zip if self.zip
    string_address
  end

  def self.get_physical(person)
    return nil unless person
    address = PersonAddress.find_by person: person, physical: true
    address.geocode_if_necessary if address
    address
  end

  def self.update_from_connect minutes, automated = false
    offset = Time.zone_offset(Time.zone.now.strftime('%Z')) / 60
    offset = offset * -1
    minutes = minutes + offset
    connect_connection = ConnectDatabaseConnection.establish_connection(:rbd_connect_production).connection
    results = connect_connection.select_all "select

      u.ad_user_id

      from ad_user u
      left outer join c_bpartner bp
        on bp.c_bpartner_id = u.c_bpartner_id
      left outer join c_bpartner_location l
        on l.c_bpartner_id = bp.c_bpartner_id
      left outer join c_location a
        on a.c_location_id = l.c_location_id

      where
        a.c_location_id is not null
        AND (a.updated >= current_timestamp - interval '#{minutes.to_s} minutes'
          OR l.updated >= current_timestamp - interval '#{minutes.to_s} minutes')"

    return unless results and results.count > 0
    results.each do |row|
      cu = ConnectUser.find_by ad_user_id: row['ad_user_id']
      next unless cu
      pu = PersonUpdater.new cu
      pu.update
    end
    ProcessLog.create process_class: "PersonAddress",
                      records_processed: results.count,
                      notes: "update_from_connect(#{minutes.to_s})" if automated
  end

  def geocode_if_necessary
    return unless Rails.env.production? or Rails.env.staging?
    unless self.latitude and self.longitude
      self.geocode
      if self.latitude and self.longitude
        time_zone_result = GoogleTimezone.fetch self.latitude, self.longitude
        self.time_zone = time_zone_result.time_zone_id if time_zone_result
        self.save
      end
    end
  end
end
