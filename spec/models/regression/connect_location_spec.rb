require 'rails_helper'

RSpec.describe ConnectLocation, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :connect_state }
  it { is_expected.to have_one :connect_business_partner_location }
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :c_location_id }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :address1 }
  it { is_expected.to have_db_column :address2 }
  it { is_expected.to have_db_column :city }
  it { is_expected.to have_db_column :postal }
  it { is_expected.to have_db_column :postal_add }
  it { is_expected.to have_db_column :c_country_id }
  it { is_expected.to have_db_column :c_region_id }
  it { is_expected.to have_db_column :c_city_id }
  it { is_expected.to have_db_column :regionname }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end