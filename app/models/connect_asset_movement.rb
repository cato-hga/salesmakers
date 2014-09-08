#TODO: TEST ME
# Openbravo asset movements
class ConnectAssetMovement < ConnectModel
  # Openbravo table name
  self.table_name = :rc_asset_movement
  # Openbravo table primary key
  self.primary_key = :rc_asset_movement_id

  belongs_to :connect_asset,
             primary_key: 'rc_asset_id',
             foreign_key: 'rc_asset_id'
  belongs_to :moved_from_user,
             class_name: 'ConnectUser',
             primary_key: 'ad_user_id',
             foreign_key: 'from_user'
  belongs_to :moved_to_user,
             class_name: 'ConnectUser',
             primary_key: 'ad_user_id',
             foreign_key: 'to_user'

  default_scope { order('created ASC') }

  def self.ascending_by_asset
    unscoped.order 'rc_asset_id ASC, created ASC'
  end
end
