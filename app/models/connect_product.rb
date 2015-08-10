# == Schema Information
#
# Table name: m_product
#
#  m_product_id              :string(32)       not null, primary key
#  ad_client_id              :string(32)       not null
#  ad_org_id                 :string(32)       not null
#  isactive                  :string(1)        default("Y"), not null
#  created                   :datetime         not null
#  createdby                 :string(32)       not null
#  updated                   :datetime         not null
#  updatedby                 :string(32)       not null
#  value                     :string(40)       not null
#  name                      :string(60)       not null
#  description               :string(255)
#  documentnote              :string(2000)
#  help                      :string(2000)
#  upc                       :string(30)
#  sku                       :string(30)
#  c_uom_id                  :string(32)       not null
#  salesrep_id               :string(32)
#  issummary                 :string(1)        default("N"), not null
#  isstocked                 :string(1)        default("Y"), not null
#  ispurchased               :string(1)        default("Y"), not null
#  issold                    :string(1)        default("Y"), not null
#  isbom                     :string(1)        default("N"), not null
#  isinvoiceprintdetails     :string(1)        default("N"), not null
#  ispicklistprintdetails    :string(1)        default("N"), not null
#  isverified                :string(1)        default("N"), not null
#  m_product_category_id     :string(32)       not null
#  classification            :string(1)
#  volume                    :decimal(, )      default(0.0)
#  weight                    :decimal(, )      default(0.0)
#  shelfwidth                :decimal(10, )
#  shelfheight               :decimal(10, )
#  shelfdepth                :decimal(10, )
#  unitsperpallet            :decimal(10, )
#  c_taxcategory_id          :string(32)       not null
#  s_resource_id             :string(32)
#  discontinued              :string(1)        default("N")
#  discontinuedby            :datetime
#  processing                :string(1)        default("N"), not null
#  s_expensetype_id          :string(32)
#  producttype               :string(60)       default("I"), not null
#  imageurl                  :string(120)
#  descriptionurl            :string(120)
#  guaranteedays             :decimal(10, )
#  versionno                 :string(20)
#  m_attributeset_id         :string(32)
#  m_attributesetinstance_id :string(32)
#  downloadurl               :string(120)
#  m_freightcategory_id      :string(32)
#  m_locator_id              :string(32)
#  ad_image_id               :string(32)
#  c_bpartner_id             :string(32)
#  ispriceprinted            :string(1)
#  name2                     :string(60)
#  costtype                  :string(60)
#  coststd                   :decimal(, )
#  stock_min                 :decimal(10, )
#  enforce_attribute         :string(1)        default("N")
#  calculated                :string(1)        default("N"), not null
#  ma_processplan_id         :string(32)
#  production                :string(1)        default("N"), not null
#  capacity                  :decimal(, )
#  delaymin                  :decimal(, )
#  mrp_planner_id            :string(32)
#  mrp_planningmethod_id     :string(32)
#  qtymax                    :decimal(, )
#  qtymin                    :decimal(, )
#  qtystd                    :decimal(, )
#  qtytype                   :string(1)
#  stockmin                  :decimal(, )
#  attrsetvaluetype          :string(60)
#

class ConnectProduct < RealConnectModel
  # Openbravo table name
  self.table_name = 'm_product'
  # Openbravo table primary key column
  self.primary_key = 'm_product_id'

  # Relationship for the Openbravo asset records
  has_many :connect_order_lines,
           foreign_key: 'm_product_id'
end
