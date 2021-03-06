require 'rails_helper'

RSpec.describe ConnectAssetGroup, regressor: true do

  # === Relations ===
  
  
  it { is_expected.to have_many :connect_assets }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :a_asset_group_id }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :description }
  it { is_expected.to have_db_column :help }
  it { is_expected.to have_db_column :isowned }
  it { is_expected.to have_db_column :isdepreciated }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end