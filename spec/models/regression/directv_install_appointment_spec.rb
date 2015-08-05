require 'rails_helper'

RSpec.describe DirecTVInstallAppointment, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :directv_sale }
  it { is_expected.to belong_to :directv_install_time_slot }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :directv_install_time_slot_id }
  it { is_expected.to have_db_column :directv_sale_id }
  it { is_expected.to have_db_column :install_date }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["directv_install_time_slot_id"] }
  it { is_expected.to have_db_index ["directv_sale_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :directv_sale }
  it { is_expected.to validate_presence_of :directv_install_time_slot }
  it { is_expected.to validate_presence_of :install_date }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end