require 'rails_helper'

RSpec.describe ConnectOrderPayout, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :connect_user }
  it { is_expected.to belong_to :connect_order }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :rc_order_payout_id }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :ad_user_id }
  it { is_expected.to have_db_column :hps }
  it { is_expected.to have_db_column :payout }
  it { is_expected.to have_db_column :rc_paycheck_id }
  it { is_expected.to have_db_column :c_order_id }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end