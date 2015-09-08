require 'rails_helper'

RSpec.describe ConnectOverrideGiftCard, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :creator }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :rvon_override_card_id }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :card_number }
  it { is_expected.to have_db_column :original_card_number }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end