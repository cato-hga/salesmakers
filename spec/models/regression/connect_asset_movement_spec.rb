require 'rails_helper'

RSpec.describe ConnectAssetMovement, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :connect_asset }
  it { is_expected.to belong_to :moved_from_user }
  it { is_expected.to belong_to :moved_to_user }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :rc_asset_movement_id }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :from_user }
  it { is_expected.to have_db_column :to_user }
  it { is_expected.to have_db_column :rc_asset_id }
  it { is_expected.to have_db_column :tracking }
  it { is_expected.to have_db_column :note }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end