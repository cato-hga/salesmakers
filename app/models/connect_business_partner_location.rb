# == Schema Information
#
# Table name: c_bpartner_location
#
#  c_bpartner_location_id :string(32)       not null, primary key
#  ad_client_id           :string(32)       not null
#  ad_org_id              :string(32)       not null
#  isactive               :string(1)        default("Y"), not null
#  created                :datetime         not null
#  createdby              :string(32)       not null
#  updated                :datetime         not null
#  updatedby              :string(32)       not null
#  name                   :string(60)       not null
#  isbillto               :string(1)        default("Y"), not null
#  isshipto               :string(1)        default("Y"), not null
#  ispayfrom              :string(1)        default("Y"), not null
#  isremitto              :string(1)        default("Y"), not null
#  phone                  :string(40)
#  phone2                 :string(40)
#  fax                    :string(40)
#  c_salesregion_id       :string(32)
#  c_bpartner_id          :string(32)       not null
#  c_location_id          :string(32)
#  istaxlocation          :string(1)        default("N"), not null
#  upc                    :string(30)
#

class ConnectBusinessPartnerLocation < ConnectModel
  self.table_name = :c_bpartner_location
  self.primary_key = :c_bpartner_location_id

  belongs_to :connect_business_partner,
             primary_key: 'c_bpartner_id',
             foreign_key: 'c_bpartner_id'
  has_one :connect_business_partner_location,
          foreign_key: 'c_bpartner_location_id',
          primary_key: 'name'
  belongs_to :connect_region,
             foreign_key: 'c_salesregion_id',
             primary_key: 'c_salesregion_id'
  has_one :connect_location,
          foreign_key: 'c_location_id',
          primary_key: 'c_location_id'

  def city
    parts = get_parts
    return nil if parts.count < 2
    parts[1].sub(/Event Team/, '').strip
  end

  def display_name
    parts = get_parts
    return nil if parts.count < 3
    parts[2]
  end

  def store_number
    if self.fax
      stripped = self.fax.sub /SP/, ''
      stripped = stripped.sub /DT/, ''
      stripped = stripped.sub /POST/, ''
      stripped = stripped.sub /RS/, ''
      stripped = stripped.sub /WM/, ''
      stripped = stripped.sub /CC/, ''
      stripped = stripped.sub /FR/, ''
    end
    return stripped if defined? stripped
    self.c_bpartner_location_id
  end

  def area
    return nil unless self.connect_region
    Area.find_by connect_salesregion_id: self.connect_region.c_salesregion_id
  end

  private

  def get_parts
    location_name = self.name
    return nil unless location_name
    location_name[0] = '' if location_name[0] == '.'
    parts = location_name.split(',')
    if parts.length > 3
      parts = parts[parts.length-3..parts.length-1]
    end
    stripped = Array.new
    parts.each do |part|
      stripped << part.strip
    end
    stripped
  end
end
