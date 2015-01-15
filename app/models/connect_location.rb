class ConnectLocation < ConnectModel
  self.table_name = :c_location
  self.primary_key = :c_location_id

  has_one :connect_business_partner_location,
          foreign_key: 'c_location_id',
          primary_key: 'c_location_id'
  belongs_to :connect_state,
             foreign_key: 'c_region_id',
             primary_key: 'c_region_id'
end
