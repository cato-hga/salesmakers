require 'rails_helper'

RSpec.describe ConnectBusinessPartnerSalaryCategory, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :connect_business_partner }
  it { is_expected.to belong_to :connect_salary_category }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :c_bp_salcategory_id }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :c_bpartner_id }
  it { is_expected.to have_db_column :c_salary_category_id }
  it { is_expected.to have_db_column :datefrom }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end