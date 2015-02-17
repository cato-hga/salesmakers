# Openbravo orders
class ConnectOrderLine < RealConnectModel
  # Openbravo table name
  self.table_name = 'c_orderline'
  # Openbravo table primary key column
  self.primary_key = 'c_orderline_id'

  # Relationship for the Openbravo asset records
  belongs_to :connect_order,
           primary_key: 'c_order_id',
           foreign_key: 'c_order_id'
  belongs_to :connect_product,
             primary_key: 'm_product_id',
             foreign_key: 'm_product_id'
end
