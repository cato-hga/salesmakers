# Openbravo orders
class ConnectOrder < RealConnectModel
  # Openbravo table name
  self.table_name = 'c_order'
  # Openbravo table primary key column
  self.primary_key = 'c_order_id'

  # Relationship for the Openbravo asset records
  belongs_to :connect_user,
           primary_key: 'ad_user_id',
           foreign_key: 'salesrep_id'
  has_many :connect_order_payouts,
           foreign_key: 'ad_user_id'
  belongs_to :connect_business_partner_location,
             foreign_key: 'c_bpartner_location_id',
             primary_key: 'c_bpartner_location_id'

  scope :today, -> {
    beginning_date_time = Date.today.beginning_of_day + 3.hours + Time.zone_offset('EST')
    end_date_time = Date.today.end_of_day + 3.hours + Time.zone_offset('EST')
    where('dateordered >= ?', beginning_date_time).where('dateordered < ?', end_date_time)
  }

  scope :this_month, -> {
    beginning_date_time = Date.today.beginning_of_month.to_datetime + 3.hours + Time.zone_offset('EST')
    end_date_time = Date.today.end_of_week.to_datetime + 3.hours + Time.zone_offset('EST')
    self.where('dateordered >= ?', beginning_date_time).where('dateordered < ?', end_date_time)
  }

  scope :this_week, -> {
    beginning_date_time = Date.today.beginning_of_week.to_datetime + 3.hours + Time.zone_offset('EST')
    end_date_time = Date.today.end_of_week.to_datetime + 3.hours + Time.zone_offset('EST')
    self.where('dateordered >= ?', beginning_date_time).where('dateordered < ?', end_date_time)
  }

  scope :sales, -> {
    where "documentno LIKE '%+'"
  }

  def location
    if self.connect_business_partner_location and
        self.connect_business_partner_location.connect_business_partner_location
      self.connect_business_partner_location.connect_business_partner_location
    else
      nil
    end
  end

  def connect_region
    if self.connect_business_partner_location and
        self.connect_business_partner_location.connect_business_partner_location and
        self.connect_business_partner_location.connect_business_partner_location.connect_region
      self.connect_business_partner_location.connect_business_partner_location.connect_region
    else
      nil
    end
  end

  def area
    connect_salesregion = self.connect_region
    return nil unless connect_salesregion
    Area.find_by connect_salesregion_id: connect_salesregion.c_salesregion_id
  end

  def person
    return nil unless self.connect_user
    Person.find_by connect_user_id: self.connect_user.ad_user_id
  end

  # Not currently being used
  # def self.refunds
  #   self.where "documentno LIKE '%-'"
  # end
end
