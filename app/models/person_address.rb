class PersonAddress < ActiveRecord::Base
  states = Array[ "AK", "AL", "AR", "AS", "AZ", "CA", "CO",
                  "CT", "DC", "DE", "FL", "GA", "GU", "HI",
                  "IA", "ID", "IL", "IN", "KS", "KY", "LA",
                  "MA", "MD", "ME", "MI", "MN", "MO", "MS",
                  "MT", "NC", "ND", "NE", "NH", "NJ", "NM",
                  "NV", "NY", "OH", "OK", "OR", "PA", "PR",
                  "RI", "SC", "SD", "TN", "TX", "UT", "VA",
                  "VI", "VT", "WA", "WI", "WV", "WY" ]

  validates :person, presence: true
  validates :line_1, format: { with: /\A\d\d+[A-Za-z]? .{2,}\z/, message: 'must be a valid street address' }
  validates :city, length: { minimum: 2 }
  validates :state, length: { is: 2 }, inclusion: { in: states }
  validates :zip, format: { with: /\A\d{5}\z/, message: 'must be 5 digits' }

  belongs_to :person

  def state=(value)
    unless value
      self[:state] = value
      return
    end
    self[:state] = value.upcase
  end

  def self.update_from_connect(minutes)
    offset = Time.zone_offset(Time.zone.now.strftime('%Z')) / 60
    offset = offset * -1
    minutes = minutes + offset
    puts minutes.to_s + ' Minutes'
    establish_connection(:rbd_connect_production)
    puts connection.current_database
    results = connection.select_all "select

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
        AND a.updated >= current_timestamp - interval '#{minutes.to_s} minutes'"

    puts results.count.to_s + ' Results'

    establish_connection(Rails.env.to_sym)

    return unless results and results.count > 0

    results.each do |row|
      cu = ConnectUser.find_by ad_user_id: row['ad_user_id']
      next unless cu
      pu = PersonUpdater.new cu
      pu.update
    end
  end
end
