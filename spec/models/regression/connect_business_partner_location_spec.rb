require 'rails_helper'

RSpec.describe ConnectBusinessPartnerLocation, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :connect_business_partner }
  it { is_expected.to belong_to :connect_region }
  it { is_expected.to have_one :connect_business_partner_location }
  it { is_expected.to have_one :connect_location }
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :c_bpartner_location_id }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :isbillto }
  it { is_expected.to have_db_column :isshipto }
  it { is_expected.to have_db_column :ispayfrom }
  it { is_expected.to have_db_column :isremitto }
  it { is_expected.to have_db_column :phone }
  it { is_expected.to have_db_column :phone2 }
  it { is_expected.to have_db_column :fax }
  it { is_expected.to have_db_column :c_salesregion_id }
  it { is_expected.to have_db_column :c_bpartner_id }
  it { is_expected.to have_db_column :c_location_id }
  it { is_expected.to have_db_column :istaxlocation }
  it { is_expected.to have_db_column :upc }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end