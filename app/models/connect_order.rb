# == Schema Information
#
# Table name: c_order
#
#  c_order_id             :string(32)       not null, primary key
#  ad_client_id           :string(32)       not null
#  ad_org_id              :string(32)       not null
#  isactive               :string(1)        default("Y"), not null
#  created                :datetime         not null
#  createdby              :string(32)       not null
#  updated                :datetime         not null
#  updatedby              :string(32)       not null
#  issotrx                :string(1)        default("Y"), not null
#  documentno             :string(30)       not null
#  docstatus              :string(60)       not null
#  docaction              :string(60)       not null
#  processing             :string(1)
#  processed              :string(1)        default("N"), not null
#  c_doctype_id           :string(32)       not null
#  c_doctypetarget_id     :string(32)       not null
#  description            :string(255)
#  isdelivered            :string(1)        default("N"), not null
#  isinvoiced             :string(1)        default("N"), not null
#  isprinted              :string(1)        default("N"), not null
#  isselected             :string(1)        default("N"), not null
#  salesrep_id            :string(32)
#  dateordered            :datetime         not null
#  datepromised           :datetime
#  dateprinted            :datetime
#  dateacct               :datetime         not null
#  c_bpartner_id          :string(32)       not null
#  billto_id              :string(32)
#  c_bpartner_location_id :string(32)       not null
#  poreference            :string(20)
#  isdiscountprinted      :string(1)        default("Y"), not null
#  c_currency_id          :string(32)       not null
#  paymentrule            :string(60)       not null
#  c_paymentterm_id       :string(32)       not null
#  invoicerule            :string(60)       not null
#  deliveryrule           :string(60)       not null
#  freightcostrule        :string(60)       not null
#  freightamt             :decimal(, )      default(0.0)
#  deliveryviarule        :string(60)       not null
#  m_shipper_id           :string(32)
#  c_charge_id            :string(32)
#  chargeamt              :decimal(, )      default(0.0)
#  priorityrule           :string(60)       not null
#  totallines             :decimal(, )      default(0.0), not null
#  grandtotal             :decimal(, )      default(0.0), not null
#  m_warehouse_id         :string(32)       not null
#  m_pricelist_id         :string(32)       not null
#  istaxincluded          :string(1)        default("N")
#  c_campaign_id          :string(32)
#  c_project_id           :string(32)
#  c_activity_id          :string(32)
#  posted                 :string(60)       default("N"), not null
#  ad_user_id             :string(32)
#  copyfrom               :string(1)
#  dropship_bpartner_id   :string(32)
#  dropship_location_id   :string(32)
#  dropship_user_id       :string(32)
#  isselfservice          :string(1)        default("N"), not null
#  ad_orgtrx_id           :string(32)
#  user1_id               :string(32)
#  user2_id               :string(32)
#  deliverynotes          :string(2000)
#  c_incoterms_id         :string(32)
#  incotermsdescription   :string(255)
#  generatetemplate       :string(1)
#  delivery_location_id   :string(32)
#  copyfrompo             :string(1)
#  fin_paymentmethod_id   :string(32)
#

# Openbravo orders
class ConnectOrder < RealConnectModel
  include ConnectScopes

  # Openbravo table name
  self.table_name = 'c_order'
  # Openbravo table primary key column
  self.primary_key = 'c_order_id'

  # Relationship for the Openbravo asset records
  belongs_to :connect_user,
           primary_key: 'ad_user_id',
           foreign_key: 'salesrep_id'
  has_many :connect_order_payouts,
           foreign_key: 'ad_user_id'
  belongs_to :connect_business_partner_location,
             foreign_key: 'c_bpartner_location_id',
             primary_key: 'c_bpartner_location_id'
  has_many :connect_order_lines,
           foreign_key: 'c_order_id'
  belongs_to :connect_business_partner,
             primary_key: 'c_bpartner_id',
             foreign_key: 'c_bpartner_id'

  scope :today, -> {
    beginning_date_time = Date.today.beginning_of_day.apply_eastern_offset + 3.hours
    end_date_time = Date.today.end_of_day.apply_eastern_offset + 3.hours
    where('dateordered >= ?', beginning_date_time).where('dateordered < ?', end_date_time)
  }

  scope :this_month, -> {
    beginning_date_time = Date.today.beginning_of_month.to_time.apply_eastern_offset + 3.hours
    end_date_time = Date.today.end_of_week.to_time.apply_eastern_offset + 3.hours
    self.where('dateordered >= ?', beginning_date_time).where('dateordered < ?', end_date_time)
  }

  scope :this_week, -> {
    beginning_date_time = Date.today.beginning_of_week.to_time.apply_eastern_offset + 3.hours
    end_date_time = Date.today.end_of_week.to_time.apply_eastern_offset + 3.hours
    self.where('dateordered >= ?', beginning_date_time).where('dateordered < ?', end_date_time)
  }

  scope :sales, -> {
    where "documentno LIKE '%+' AND documentno NOT LIKE '%X%'"
  }

  scope :resales, -> {
    where "documentno LIKE '%X%+'"
  }

  def dateordered
    self[:dateordered].remove_eastern_offset
  end

  def location
    if self.connect_business_partner_location and
        self.connect_business_partner_location.connect_business_partner_location
      self.connect_business_partner_location.connect_business_partner_location
    else
      nil
    end
  end

  def connect_region
    if self.connect_business_partner_location and
        self.connect_business_partner_location.connect_business_partner_location and
        self.connect_business_partner_location.connect_business_partner_location.connect_region
      self.connect_business_partner_location.connect_business_partner_location.connect_region
    else
      nil
    end
  end

  def area
    connect_salesregion = self.connect_region
    return nil unless connect_salesregion
    Area.find_by connect_salesregion_id: connect_salesregion.c_salesregion_id
  end

  def person
    return nil unless self.connect_user
    Person.find_by connect_user_id: self.connect_user.ad_user_id
  end

  # Not currently being used
  # def self.refunds
  #   self.where "documentno LIKE '%-'"
  # end
end
