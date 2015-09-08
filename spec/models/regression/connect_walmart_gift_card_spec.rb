require 'rails_helper'

RSpec.describe ConnectWalmartGiftCard, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :creator }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :rvon_walmart_gift_card_id }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :link }
  it { is_expected.to have_db_column :challenge_code }
  it { is_expected.to have_db_column :card_number }
  it { is_expected.to have_db_column :pin }
  it { is_expected.to have_db_column :balance }
  it { is_expected.to have_db_column :purchase_date }
  it { is_expected.to have_db_column :store_number }
  it { is_expected.to have_db_column :purchase_amount }
  it { is_expected.to have_db_column :m_product_id }
  it { is_expected.to have_db_column :ad_user_id }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end