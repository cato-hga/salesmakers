require 'rails_helper'

RSpec.describe ConnectBusinessPartner, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :connect_user }
  it { is_expected.to have_one :connect_salary_category }
  it { is_expected.to have_many :connect_business_partner_salary_categories }
  it { is_expected.to have_many :connect_business_partner_locations }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :c_bpartner_id }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :value }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :name2 }
  it { is_expected.to have_db_column :description }
  it { is_expected.to have_db_column :issummary }
  it { is_expected.to have_db_column :c_bp_group_id }
  it { is_expected.to have_db_column :isonetime }
  it { is_expected.to have_db_column :isprospect }
  it { is_expected.to have_db_column :isvendor }
  it { is_expected.to have_db_column :iscustomer }
  it { is_expected.to have_db_column :isemployee }
  it { is_expected.to have_db_column :issalesrep }
  it { is_expected.to have_db_column :referenceno }
  it { is_expected.to have_db_column :duns }
  it { is_expected.to have_db_column :url }
  it { is_expected.to have_db_column :ad_language }
  it { is_expected.to have_db_column :taxid }
  it { is_expected.to have_db_column :istaxexempt }
  it { is_expected.to have_db_column :c_invoiceschedule_id }
  it { is_expected.to have_db_column :rating }
  it { is_expected.to have_db_column :salesvolume }
  it { is_expected.to have_db_column :numberemployees }
  it { is_expected.to have_db_column :naics }
  it { is_expected.to have_db_column :firstsale }
  it { is_expected.to have_db_column :acqusitioncost }
  it { is_expected.to have_db_column :potentiallifetimevalue }
  it { is_expected.to have_db_column :actuallifetimevalue }
  it { is_expected.to have_db_column :shareofcustomer }
  it { is_expected.to have_db_column :paymentrule }
  it { is_expected.to have_db_column :so_creditlimit }
  it { is_expected.to have_db_column :so_creditused }
  it { is_expected.to have_db_column :c_paymentterm_id }
  it { is_expected.to have_db_column :m_pricelist_id }
  it { is_expected.to have_db_column :isdiscountprinted }
  it { is_expected.to have_db_column :so_description }
  it { is_expected.to have_db_column :poreference }
  it { is_expected.to have_db_column :paymentrulepo }
  it { is_expected.to have_db_column :po_pricelist_id }
  it { is_expected.to have_db_column :po_paymentterm_id }
  it { is_expected.to have_db_column :documentcopies }
  it { is_expected.to have_db_column :c_greeting_id }
  it { is_expected.to have_db_column :invoicerule }
  it { is_expected.to have_db_column :deliveryrule }
  it { is_expected.to have_db_column :deliveryviarule }
  it { is_expected.to have_db_column :salesrep_id }
  it { is_expected.to have_db_column :bpartner_parent_id }
  it { is_expected.to have_db_column :socreditstatus }
  it { is_expected.to have_db_column :ad_forced_org_id }
  it { is_expected.to have_db_column :showpriceinorder }
  it { is_expected.to have_db_column :invoicegrouping }
  it { is_expected.to have_db_column :fixmonthday }
  it { is_expected.to have_db_column :fixmonthday2 }
  it { is_expected.to have_db_column :fixmonthday3 }
  it { is_expected.to have_db_column :isworker }
  it { is_expected.to have_db_column :upc }
  it { is_expected.to have_db_column :c_salary_category_id }
  it { is_expected.to have_db_column :invoice_printformat }
  it { is_expected.to have_db_column :last_days }
  it { is_expected.to have_db_column :po_bankaccount_id }
  it { is_expected.to have_db_column :po_bp_taxcategory_id }
  it { is_expected.to have_db_column :po_fixmonthday }
  it { is_expected.to have_db_column :po_fixmonthday2 }
  it { is_expected.to have_db_column :po_fixmonthday3 }
  it { is_expected.to have_db_column :so_bankaccount_id }
  it { is_expected.to have_db_column :so_bp_taxcategory_id }
  it { is_expected.to have_db_column :fiscalcode }
  it { is_expected.to have_db_column :isofiscalcode }
  it { is_expected.to have_db_column :po_c_incoterms_id }
  it { is_expected.to have_db_column :so_c_incoterms_id }
  it { is_expected.to have_db_column :fin_paymentmethod_id }
  it { is_expected.to have_db_column :po_paymentmethod_id }
  it { is_expected.to have_db_column :fin_financial_account_id }
  it { is_expected.to have_db_column :po_financial_account_id }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end