# == Schema Information
#
# Table name: c_region
#
#  c_region_id  :string(32)       not null, primary key
#  ad_client_id :string(32)       not null
#  ad_org_id    :string(32)       not null
#  isactive     :string(1)        default("Y"), not null
#  created      :datetime         not null
#  createdby    :string(32)       not null
#  updated      :datetime         not null
#  updatedby    :string(32)       not null
#  name         :string(60)       not null
#  description  :string(255)
#  c_country_id :string(32)       not null
#  isdefault    :string(1)        default("N")
#  value        :string(2)
#

class ConnectState < ConnectModel
  self.table_name = :c_region
  self.primary_key = :c_region_id

  has_many :connect_locations,
           foreign_key: 'c_region_id',
           primary_key: 'c_region_id'
end
