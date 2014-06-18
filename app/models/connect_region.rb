require 'simple_tree'

class ConnectRegion < ConnectModel
  include SimpleTree

  self.table_name = :c_salesregion
  self.primary_key = :c_salesregion_id

end