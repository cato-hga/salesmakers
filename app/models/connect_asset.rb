#TODO: TEST ME

# Openbravo assets. These should remain read-only (usually for the
# purposes of imports)
class ConnectAsset < ConnectModel
  # Openbravo table name
  self.table_name = :rc_asset
  # Primary key for the Openbravo table
  self.primary_key = :rc_asset_id

  # Openbravo user relationship
  belongs_to :connect_user,
             primary_key: 'ad_user_id',
             foreign_key: 'ad_user_id'
  # Openbravo "asset type" relationship
  belongs_to :connect_asset_group,
             primary_key: 'a_asset_group_id',
             foreign_key: 'a_asset_group_id'
  # Openbravo asset movements
  has_many :connect_asset_movements,
           primary_key: 'rc_asset_id',
           foreign_key: 'rc_asset_id'
end
