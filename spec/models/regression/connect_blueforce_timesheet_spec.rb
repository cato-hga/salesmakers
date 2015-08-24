require 'rails_helper'

RSpec.describe ConnectBlueforceTimesheet, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :connect_user }
  it { is_expected.to belong_to :connect_business_partner_location }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :rsprint_timesheet_id }
  it { is_expected.to have_db_column :createdby }
  it { is_expected.to have_db_column :updatedby }
  it { is_expected.to have_db_column :created }
  it { is_expected.to have_db_column :updated }
  it { is_expected.to have_db_column :isactive }
  it { is_expected.to have_db_column :ad_client_id }
  it { is_expected.to have_db_column :ad_org_id }
  it { is_expected.to have_db_column :shift_date }
  it { is_expected.to have_db_column :employee_login }
  it { is_expected.to have_db_column :site_num }
  it { is_expected.to have_db_column :site_name }
  it { is_expected.to have_db_column :eid }
  it { is_expected.to have_db_column :first_name }
  it { is_expected.to have_db_column :last_name }
  it { is_expected.to have_db_column :hours }
  it { is_expected.to have_db_column :timesheet_row }
  it { is_expected.to have_db_column :c_bpartner_location_id }
  it { is_expected.to have_db_column :ad_user_id }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end