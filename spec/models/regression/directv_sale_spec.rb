require 'rails_helper'

RSpec.describe DirecTVSale, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :directv_customer }
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :directv_lead }
  it { is_expected.to have_one :directv_former_provider }
  it { is_expected.to have_one :directv_install_appointment }
  

  # === Nested Attributes ===
  it { is_expected.to accept_nested_attributes_for :directv_install_appointment }

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :order_date }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :directv_customer_id }
  it { is_expected.to have_db_column :order_number }
  it { is_expected.to have_db_column :directv_former_provider_id }
  it { is_expected.to have_db_column :directv_lead_id }
  it { is_expected.to have_db_column :customer_acknowledged }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["directv_customer_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :order_date }
  it { is_expected.to validate_presence_of :person_id }
  it { is_expected.to validate_presence_of :directv_customer_id }
  it { is_expected.to validate_presence_of :directv_install_appointment }

  # === Validations (Numericality) ===
  it { is_expected.to validate_numericality_of(:order_number).only_integer }

  
  # === Enums ===
  
  
end