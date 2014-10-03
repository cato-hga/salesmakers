# Openbravo orders
class ConnectSprintSale < RealConnectModel
  # Openbravo table name
  self.table_name = 'rsprint_sales'
  # Openbravo table primary key column
  self.primary_key = 'rsprint_sales_id'

  # Relationship for the Openbravo asset records
  belongs_to :connect_user,
           primary_key: 'ad_user_id',
           foreign_key: 'ad_user_id'
  belongs_to :connect_business_partner_location,
             foreign_key: 'c_bpartner_location_id',
             primary_key: 'c_bpartner_location_id'

  def location
    if self.connect_business_partner_location
      self.connect_business_partner_location
    else
      nil
    end
  end

  def connect_region
    if self.connect_business_partner_location
      self.connect_business_partner_location.connect_region
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

end
