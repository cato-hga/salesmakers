# == Schema Information
#
# Table name: c_bpartner
#
#  c_bpartner_id            :string(32)       not null, primary key
#  ad_client_id             :string(32)       not null
#  ad_org_id                :string(32)       not null
#  isactive                 :string(1)        default("Y"), not null
#  created                  :datetime         not null
#  createdby                :string(32)       not null
#  updated                  :datetime         not null
#  updatedby                :string(32)       not null
#  value                    :string(40)       not null
#  name                     :string(60)       not null
#  name2                    :string(60)
#  description              :string(255)
#  issummary                :string(1)        default("N"), not null
#  c_bp_group_id            :string(32)       not null
#  isonetime                :string(1)        default("N"), not null
#  isprospect               :string(1)        default("Y"), not null
#  isvendor                 :string(1)        default("N"), not null
#  iscustomer               :string(1)        default("Y"), not null
#  isemployee               :string(1)        default("N"), not null
#  issalesrep               :string(1)        default("N"), not null
#  referenceno              :string(40)
#  duns                     :string(11)
#  url                      :string(120)
#  ad_language              :string(6)
#  taxid                    :string(20)
#  istaxexempt              :string(1)        default("N")
#  c_invoiceschedule_id     :string(32)
#  rating                   :string(1)
#  salesvolume              :decimal(10, )
#  numberemployees          :decimal(10, )
#  naics                    :string(6)
#  firstsale                :datetime
#  acqusitioncost           :decimal(, )      default(0.0)
#  potentiallifetimevalue   :decimal(, )      default(0.0)
#  actuallifetimevalue      :decimal(, )      default(0.0)
#  shareofcustomer          :decimal(10, )
#  paymentrule              :string(60)
#  so_creditlimit           :decimal(, )      default(0.0)
#  so_creditused            :decimal(, )      default(0.0)
#  c_paymentterm_id         :string(32)
#  m_pricelist_id           :string(32)
#  isdiscountprinted        :string(1)        default("Y")
#  so_description           :string(255)
#  poreference              :string(20)
#  paymentrulepo            :string(60)
#  po_pricelist_id          :string(32)
#  po_paymentterm_id        :string(32)
#  documentcopies           :decimal(10, )
#  c_greeting_id            :string(32)
#  invoicerule              :string(60)
#  deliveryrule             :string(60)
#  deliveryviarule          :string(60)
#  salesrep_id              :string(32)
#  bpartner_parent_id       :string(32)
#  socreditstatus           :string(60)       default("O")
#  ad_forced_org_id         :string(32)
#  showpriceinorder         :string(1)        default("Y"), not null
#  invoicegrouping          :string(60)
#  fixmonthday              :decimal(10, )
#  fixmonthday2             :decimal(10, )
#  fixmonthday3             :decimal(10, )
#  isworker                 :string(1)        default("N")
#  upc                      :string(30)
#  c_salary_category_id     :string(32)
#  invoice_printformat      :string(60)
#  last_days                :decimal(10, )
#  po_bankaccount_id        :string(32)
#  po_bp_taxcategory_id     :string(32)
#  po_fixmonthday           :decimal(10, )
#  po_fixmonthday2          :decimal(10, )
#  po_fixmonthday3          :decimal(10, )
#  so_bankaccount_id        :string(32)
#  so_bp_taxcategory_id     :string(32)
#  fiscalcode               :string(16)
#  isofiscalcode            :string(2)
#  po_c_incoterms_id        :string(32)
#  so_c_incoterms_id        :string(32)
#  fin_paymentmethod_id     :string(32)
#  po_paymentmethod_id      :string(32)
#  fin_financial_account_id :string(32)
#  po_financial_account_id  :string(32)
#

class ConnectBusinessPartner < ConnectModel
  self.table_name = :c_bpartner
  self.primary_key = :c_bpartner_id

  belongs_to :connect_user,
             primary_key: 'c_bpartner_id',
             foreign_key: 'c_bpartner_id'
  has_many :connect_business_partner_salary_categories,
           foreign_key: 'c_bpartner_id',
           primary_key: 'c_bpartner_id'
  has_many :connect_business_partner_locations,
           foreign_key: 'c_bpartner_id',
           primary_key: 'c_bpartner_id'
  has_one :connect_salary_category,
          primary_key: 'c_salary_category_id',
          foreign_key: 'c_salary_category_id'

  def get_channel(fax = nil)
    case self.name
      when 'DirecTV'
        if fax and fax[0..3] == 'DTFR'
          channel_name = "Fry's"
        else
          channel_name = "Walmart"
        end
      when 'Comcast'
        channel_name = 'Walmart'
      when 'Microcenter'
        channel_name = 'Micro Center'
      when 'Sprint'
        channel_name = 'Walmart'
      when 'Sprint Radio Shack'
        channel_name = 'Radio Shack'
      when 'KMart'
        channel_name = 'Kmart'
      when 'RBD Event Teams'
        channel_name = 'Vonage Event Teams'
      else
        channel_name = self.name
    end
    Channel.find_by name: channel_name
  end
end
