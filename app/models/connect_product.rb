class ConnectProduct < RealConnectModel
  # Openbravo table name
  self.table_name = 'm_product'
  # Openbravo table primary key column
  self.primary_key = 'm_product_id'

  # Relationship for the Openbravo asset records
  has_many :connect_order_lines,
           foreign_key: 'm_product_id'
end