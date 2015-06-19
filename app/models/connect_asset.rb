# == Schema Information
#
# Table name: rc_asset
#
#  rc_asset_id       :string(32)       not null, primary key
#  created           :datetime         not null
#  updated           :datetime         not null
#  createdby         :string(32)       not null
#  updatedby         :string(32)       not null
#  isactive          :string(1)        default("Y"), not null
#  ad_client_id      :string(32)       not null
#  ad_org_id         :string(32)       not null
#  ad_user_id        :string(32)       not null
#  serial            :string(255)      not null
#  ptn               :string(255)
#  a_asset_group_id  :string(32)       not null
#  contract_end_date :datetime
#

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

  def line_identifier
    self.ptn.blank? ? nil : self.ptn.gsub(/[^0-9A-Za-z]/, '')
  end
end
