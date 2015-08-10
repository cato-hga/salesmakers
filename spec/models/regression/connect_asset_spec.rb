require 'rails_helper'

RSpec.describe ConnectAsset, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :connect_user }
  it { is_expected.to belong_to :connect_asset_group }
  
  it { is_expected.to have_many :connect_asset_movements }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :rc_asset_id }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :ad_user_id }
  it { is_expected.to have_db_column :serial }
  it { is_expected.to have_db_column :ptn }
  it { is_expected.to have_db_column :a_asset_group_id }
  it { is_expected.to have_db_column :contract_end_date }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end