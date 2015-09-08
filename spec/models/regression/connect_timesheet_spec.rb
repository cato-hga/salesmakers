require 'rails_helper'

RSpec.describe ConnectTimesheet, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :connect_user }
  it { is_expected.to belong_to :connect_business_partner_location }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :rc_timesheet_id }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :shift_date }
  it { is_expected.to have_db_column :hours }
  it { is_expected.to have_db_column :ad_user_id }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :c_bpartner_location_id }
  it { is_expected.to have_db_column :time_docked }
  it { is_expected.to have_db_column :overtime }
  it { is_expected.to have_db_column :rate_of_pay }
  it { is_expected.to have_db_column :customer }
  it { is_expected.to have_db_column :punch_ins }
  it { is_expected.to have_db_column :punch_outs }
  it { is_expected.to have_db_column :break_starts }
  it { is_expected.to have_db_column :break_ends }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end