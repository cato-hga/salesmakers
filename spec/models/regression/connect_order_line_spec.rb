require 'rails_helper'

RSpec.describe ConnectOrderLine, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :connect_order }
  it { is_expected.to belong_to :connect_product }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :c_orderline_id }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :c_order_id }
  it { is_expected.to have_db_column :line }
  it { is_expected.to have_db_column :c_bpartner_id }
  it { is_expected.to have_db_column :c_bpartner_location_id }
  it { is_expected.to have_db_column :dateordered }
  it { is_expected.to have_db_column :datepromised }
  it { is_expected.to have_db_column :datedelivered }
  it { is_expected.to have_db_column :dateinvoiced }
  it { is_expected.to have_db_column :description }
  it { is_expected.to have_db_column :m_product_id }
  it { is_expected.to have_db_column :m_warehouse_id }
  it { is_expected.to have_db_column :directship }
  it { is_expected.to have_db_column :c_uom_id }
  it { is_expected.to have_db_column :qtyordered }
  it { is_expected.to have_db_column :qtyreserved }
  it { is_expected.to have_db_column :qtydelivered }
  it { is_expected.to have_db_column :qtyinvoiced }
  it { is_expected.to have_db_column :m_shipper_id }
  it { is_expected.to have_db_column :c_currency_id }
  it { is_expected.to have_db_column :pricelist }
  it { is_expected.to have_db_column :priceactual }
  it { is_expected.to have_db_column :pricelimit }
  it { is_expected.to have_db_column :linenetamt }
  it { is_expected.to have_db_column :discount }
  it { is_expected.to have_db_column :freightamt }
  it { is_expected.to have_db_column :c_charge_id }
  it { is_expected.to have_db_column :chargeamt }
  it { is_expected.to have_db_column :c_tax_id }
  it { is_expected.to have_db_column :s_resourceassignment_id }
  it { is_expected.to have_db_column :ref_orderline_id }
  it { is_expected.to have_db_column :m_attributesetinstance_id }
  it { is_expected.to have_db_column :isdescription }
  it { is_expected.to have_db_column :quantityorder }
  it { is_expected.to have_db_column :m_product_uom_id }
  it { is_expected.to have_db_column :m_offer_id }
  it { is_expected.to have_db_column :pricestd }
  it { is_expected.to have_db_column :cancelpricead }
  it { is_expected.to have_db_column :c_order_discount_id }
  it { is_expected.to have_db_column :iseditlinenetamt }
  it { is_expected.to have_db_column :taxbaseamt }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end