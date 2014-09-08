#TODO: TEST ME

# Openbravo "asset types" (usually used for import only)
class ConnectAssetGroup < ConnectModel
  # Openbravo table name
  self.table_name = 'a_asset_group'
  # Openbravo table primary key column
  self.primary_key = 'a_asset_group_id'

  # Relationship for the Openbravo asset records
  has_many :connect_assets,
           primary_key: 'a_asset_group_id',
           foreign_key: 'a_asset_group_id'
end
