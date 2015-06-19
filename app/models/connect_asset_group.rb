# == Schema Information
#
# Table name: a_asset_group
#
#  a_asset_group_id :string(32)       not null, primary key
#  ad_client_id     :string(32)       not null
#  ad_org_id        :string(32)       not null
#  isactive         :string(1)        default("Y"), not null
#  created          :datetime         not null
#  createdby        :string(32)       not null
#  updated          :datetime         not null
#  updatedby        :string(32)       not null
#  name             :string(60)       not null
#  description      :string(255)
#  help             :string(2000)
#  isowned          :string(1)        default("Y"), not null
#  isdepreciated    :string(1)        default("Y"), not null
#

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
