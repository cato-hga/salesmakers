# == Schema Information
#
# Table name: c_location
#
#  c_location_id :string(32)       not null, primary key
#  ad_client_id  :string(32)       not null
#  ad_org_id     :string(32)       not null
#  isactive      :string(1)        default("Y"), not null
#  created       :datetime         not null
#  createdby     :string(32)       not null
#  updated       :datetime         not null
#  updatedby     :string(32)       not null
#  address1      :string(60)
#  address2      :string(60)
#  city          :string(60)
#  postal        :string(10)
#  postal_add    :string(10)
#  c_country_id  :string(32)       not null
#  c_region_id   :string(32)
#  c_city_id     :string(32)
#  regionname    :string(40)
#

class ConnectLocation < ConnectModel
  self.table_name = :c_location
  self.primary_key = :c_location_id

  has_one :connect_business_partner_location,
          foreign_key: 'c_location_id',
          primary_key: 'c_location_id'
  belongs_to :connect_state,
             foreign_key: 'c_region_id',
             primary_key: 'c_region_id'
end
