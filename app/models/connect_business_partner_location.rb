class ConnectBusinessPartnerLocation < ConnectModel
  self.table_name = :c_bpartner_location
  self.primary_key = :c_bpartner_location_id

  belongs_to :connect_business_partner,
             primary_key: 'c_bpartner_id',
             foreign_key: 'c_bpartner_id'
  has_one :connect_business_partner_location,
          foreign_key: 'c_bpartner_location_id',
          primary_key: 'name'
  belongs_to :connect_region,
             foreign_key: 'c_salesregion_id',
             primary_key: 'c_salesregion_id'
  has_one :connect_location,
          foreign_key: 'c_location_id',
          primary_key: 'c_location_id'
end
