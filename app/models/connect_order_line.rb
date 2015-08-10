# == Schema Information
#
# Table name: c_orderline
#
#  c_orderline_id            :string(32)       not null, primary key
#  ad_client_id              :string(32)       not null
#  ad_org_id                 :string(32)       not null
#  isactive                  :string(1)        default("Y"), not null
#  created                   :datetime         not null
#  createdby                 :string(32)       not null
#  updated                   :datetime         not null
#  updatedby                 :string(32)       not null
#  c_order_id                :string(32)       not null
#  line                      :decimal(10, )    not null
#  c_bpartner_id             :string(32)
#  c_bpartner_location_id    :string(32)
#  dateordered               :datetime         not null
#  datepromised              :datetime
#  datedelivered             :datetime
#  dateinvoiced              :datetime
#  description               :string(2000)
#  m_product_id              :string(32)
#  m_warehouse_id            :string(32)       not null
#  directship                :string(1)        default("N"), not null
#  c_uom_id                  :string(32)       not null
#  qtyordered                :decimal(, )      default(0.0), not null
#  qtyreserved               :decimal(, )      default(0.0), not null
#  qtydelivered              :decimal(, )      default(0.0), not null
#  qtyinvoiced               :decimal(, )      default(0.0), not null
#  m_shipper_id              :string(32)
#  c_currency_id             :string(32)       not null
#  pricelist                 :decimal(, )      default(0.0), not null
#  priceactual               :decimal(, )      default(0.0), not null
#  pricelimit                :decimal(, )      default(0.0), not null
#  linenetamt                :decimal(, )      default(0.0), not null
#  discount                  :decimal(, )
#  freightamt                :decimal(, )      default(0.0), not null
#  c_charge_id               :string(32)
#  chargeamt                 :decimal(, )      default(0.0)
#  c_tax_id                  :string(32)       not null
#  s_resourceassignment_id   :string(32)
#  ref_orderline_id          :string(32)
#  m_attributesetinstance_id :string(32)
#  isdescription             :string(1)        default("N"), not null
#  quantityorder             :decimal(, )
#  m_product_uom_id          :string(32)
#  m_offer_id                :string(32)
#  pricestd                  :decimal(, )      default(0.0), not null
#  cancelpricead             :string(1)        default("N")
#  c_order_discount_id       :string(32)
#  iseditlinenetamt          :string(1)        default("N")
#  taxbaseamt                :decimal(, )
#

# Openbravo orders
class ConnectOrderLine < RealConnectModel
  # Openbravo table name
  self.table_name = 'c_orderline'
  # Openbravo table primary key column
  self.primary_key = 'c_orderline_id'

  # Relationship for the Openbravo asset records
  belongs_to :connect_order,
           primary_key: 'c_order_id',
           foreign_key: 'c_order_id'
  belongs_to :connect_product,
             primary_key: 'm_product_id',
             foreign_key: 'm_product_id'
end
