require 'rails_helper'

RSpec.describe ConnectProduct, regressor: true do

  # === Relations ===
  
  
  it { is_expected.to have_many :connect_order_lines }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :m_product_id }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :value }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :description }
  it { is_expected.to have_db_column :documentnote }
  it { is_expected.to have_db_column :help }
  it { is_expected.to have_db_column :upc }
  it { is_expected.to have_db_column :sku }
  it { is_expected.to have_db_column :c_uom_id }
  it { is_expected.to have_db_column :salesrep_id }
  it { is_expected.to have_db_column :issummary }
  it { is_expected.to have_db_column :isstocked }
  it { is_expected.to have_db_column :ispurchased }
  it { is_expected.to have_db_column :issold }
  it { is_expected.to have_db_column :isbom }
  it { is_expected.to have_db_column :isinvoiceprintdetails }
  it { is_expected.to have_db_column :ispicklistprintdetails }
  it { is_expected.to have_db_column :isverified }
  it { is_expected.to have_db_column :m_product_category_id }
  it { is_expected.to have_db_column :classification }
  it { is_expected.to have_db_column :volume }
  it { is_expected.to have_db_column :weight }
  it { is_expected.to have_db_column :shelfwidth }
  it { is_expected.to have_db_column :shelfheight }
  it { is_expected.to have_db_column :shelfdepth }
  it { is_expected.to have_db_column :unitsperpallet }
  it { is_expected.to have_db_column :c_taxcategory_id }
  it { is_expected.to have_db_column :s_resource_id }
  it { is_expected.to have_db_column :discontinued }
  it { is_expected.to have_db_column :discontinuedby }
  it { is_expected.to have_db_column :processing }
  it { is_expected.to have_db_column :s_expensetype_id }
  it { is_expected.to have_db_column :producttype }
  it { is_expected.to have_db_column :imageurl }
  it { is_expected.to have_db_column :descriptionurl }
  it { is_expected.to have_db_column :guaranteedays }
  it { is_expected.to have_db_column :versionno }
  it { is_expected.to have_db_column :m_attributeset_id }
  it { is_expected.to have_db_column :m_attributesetinstance_id }
  it { is_expected.to have_db_column :downloadurl }
  it { is_expected.to have_db_column :m_freightcategory_id }
  it { is_expected.to have_db_column :m_locator_id }
  it { is_expected.to have_db_column :ad_image_id }
  it { is_expected.to have_db_column :c_bpartner_id }
  it { is_expected.to have_db_column :ispriceprinted }
  it { is_expected.to have_db_column :name2 }
  it { is_expected.to have_db_column :costtype }
  it { is_expected.to have_db_column :coststd }
  it { is_expected.to have_db_column :stock_min }
  it { is_expected.to have_db_column :enforce_attribute }
  it { is_expected.to have_db_column :calculated }
  it { is_expected.to have_db_column :ma_processplan_id }
  it { is_expected.to have_db_column :production }
  it { is_expected.to have_db_column :capacity }
  it { is_expected.to have_db_column :delaymin }
  it { is_expected.to have_db_column :mrp_planner_id }
  it { is_expected.to have_db_column :mrp_planningmethod_id }
  it { is_expected.to have_db_column :qtymax }
  it { is_expected.to have_db_column :qtymin }
  it { is_expected.to have_db_column :qtystd }
  it { is_expected.to have_db_column :qtytype }
  it { is_expected.to have_db_column :stockmin }
  it { is_expected.to have_db_column :attrsetvaluetype }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end