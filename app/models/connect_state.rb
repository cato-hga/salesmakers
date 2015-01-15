class ConnectState < ConnectModel
  self.table_name = :c_region
  self.primary_key = :c_region_id

  has_many :connect_locations,
           foreign_key: 'c_region_id',
           primary_key: 'c_region_id'
end
