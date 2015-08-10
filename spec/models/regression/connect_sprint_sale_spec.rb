require 'rails_helper'

RSpec.describe ConnectSprintSale, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :connect_user }
  it { is_expected.to belong_to :connect_business_partner_location }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :rsprint_sales_id }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :ad_user_id }
  it { is_expected.to have_db_column :c_bpartner_location_id }
  it { is_expected.to have_db_column :date_sold }
  it { is_expected.to have_db_column :upgrade }
  it { is_expected.to have_db_column :carrier }
  it { is_expected.to have_db_column :model }
  it { is_expected.to have_db_column :rate_plan }
  it { is_expected.to have_db_column :comments }
  it { is_expected.to have_db_column :meid }
  it { is_expected.to have_db_column :activation_assistance }
  it { is_expected.to have_db_column :picture }
  it { is_expected.to have_db_column :intl_connect_five }
  it { is_expected.to have_db_column :intl_connect_ten }
  it { is_expected.to have_db_column :insurance }
  it { is_expected.to have_db_column :top_up_card_purchased }
  it { is_expected.to have_db_column :top_up_card_amount }
  it { is_expected.to have_db_column :activated_in_store }
  it { is_expected.to have_db_column :activation_type }
  it { is_expected.to have_db_column :reason_not_activated }
  it { is_expected.to have_db_column :addon_amount }
  it { is_expected.to have_db_column :addon_description }
  it { is_expected.to have_db_column :mobile_phone }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end