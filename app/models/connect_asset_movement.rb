# == Schema Information
#
# Table name: rc_asset_movement
#
#  rc_asset_movement_id :string(32)       not null, primary key
#  created              :datetime         not null
#  updated              :datetime         not null
#  createdby            :string(32)       not null
#  updatedby            :string(32)       not null
#  isactive             :string(1)        default("Y"), not null
#  ad_client_id         :string(32)       not null
#  ad_org_id            :string(32)       not null
#  from_user            :string(32)       not null
#  to_user              :string(32)       not null
#  rc_asset_id          :string(32)       not null
#  tracking             :string(255)
#  note                 :string(255)
#

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
