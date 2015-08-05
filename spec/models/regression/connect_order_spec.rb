require 'rails_helper'

RSpec.describe ConnectOrder, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :connect_user }
  it { is_expected.to belong_to :connect_business_partner_location }
  it { is_expected.to belong_to :connect_business_partner }
  
  it { is_expected.to have_many :connect_order_payouts }
  it { is_expected.to have_many :connect_order_lines }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :c_order_id }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :issotrx }
  it { is_expected.to have_db_column :documentno }
  it { is_expected.to have_db_column :docstatus }
  it { is_expected.to have_db_column :docaction }
  it { is_expected.to have_db_column :processing }
  it { is_expected.to have_db_column :processed }
  it { is_expected.to have_db_column :c_doctype_id }
  it { is_expected.to have_db_column :c_doctypetarget_id }
  it { is_expected.to have_db_column :description }
  it { is_expected.to have_db_column :isdelivered }
  it { is_expected.to have_db_column :isinvoiced }
  it { is_expected.to have_db_column :isprinted }
  it { is_expected.to have_db_column :isselected }
  it { is_expected.to have_db_column :salesrep_id }
  it { is_expected.to have_db_column :dateordered }
  it { is_expected.to have_db_column :datepromised }
  it { is_expected.to have_db_column :dateprinted }
  it { is_expected.to have_db_column :dateacct }
  it { is_expected.to have_db_column :c_bpartner_id }
  it { is_expected.to have_db_column :billto_id }
  it { is_expected.to have_db_column :c_bpartner_location_id }
  it { is_expected.to have_db_column :poreference }
  it { is_expected.to have_db_column :isdiscountprinted }
  it { is_expected.to have_db_column :c_currency_id }
  it { is_expected.to have_db_column :paymentrule }
  it { is_expected.to have_db_column :c_paymentterm_id }
  it { is_expected.to have_db_column :invoicerule }
  it { is_expected.to have_db_column :deliveryrule }
  it { is_expected.to have_db_column :freightcostrule }
  it { is_expected.to have_db_column :freightamt }
  it { is_expected.to have_db_column :deliveryviarule }
  it { is_expected.to have_db_column :m_shipper_id }
  it { is_expected.to have_db_column :c_charge_id }
  it { is_expected.to have_db_column :chargeamt }
  it { is_expected.to have_db_column :priorityrule }
  it { is_expected.to have_db_column :totallines }
  it { is_expected.to have_db_column :grandtotal }
  it { is_expected.to have_db_column :m_warehouse_id }
  it { is_expected.to have_db_column :m_pricelist_id }
  it { is_expected.to have_db_column :istaxincluded }
  it { is_expected.to have_db_column :c_campaign_id }
  it { is_expected.to have_db_column :c_project_id }
  it { is_expected.to have_db_column :c_activity_id }
  it { is_expected.to have_db_column :posted }
  it { is_expected.to have_db_column :ad_user_id }
  it { is_expected.to have_db_column :copyfrom }
  it { is_expected.to have_db_column :dropship_bpartner_id }
  it { is_expected.to have_db_column :dropship_location_id }
  it { is_expected.to have_db_column :dropship_user_id }
  it { is_expected.to have_db_column :isselfservice }
  it { is_expected.to have_db_column :ad_orgtrx_id }
  it { is_expected.to have_db_column :user1_id }
  it { is_expected.to have_db_column :user2_id }
  it { is_expected.to have_db_column :deliverynotes }
  it { is_expected.to have_db_column :c_incoterms_id }
  it { is_expected.to have_db_column :incotermsdescription }
  it { is_expected.to have_db_column :generatetemplate }
  it { is_expected.to have_db_column :delivery_location_id }
  it { is_expected.to have_db_column :copyfrompo }
  it { is_expected.to have_db_column :fin_paymentmethod_id }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end