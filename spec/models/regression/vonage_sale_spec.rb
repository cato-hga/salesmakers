require 'rails_helper'

RSpec.describe VonageSale, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :location }
  it { is_expected.to belong_to :vonage_product }
  it { is_expected.to belong_to :connect_order }
  it { is_expected.to have_one :vonage_refund }
  it { is_expected.to have_one :vcp07012015_hps_sale }
  it { is_expected.to have_many :vonage_sale_payouts }
  it { is_expected.to have_many :vonage_account_status_changes }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :sale_date }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :confirmation_number }
  it { is_expected.to have_db_column :location_id }
  it { is_expected.to have_db_column :customer_first_name }
  it { is_expected.to have_db_column :customer_last_name }
  it { is_expected.to have_db_column :mac }
  it { is_expected.to have_db_column :vonage_product_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :connect_order_uuid }
  it { is_expected.to have_db_column :resold }
  it { is_expected.to have_db_column :vested }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["connect_order_uuid"] }
  it { is_expected.to have_db_index ["location_id"] }
  it { is_expected.to have_db_index ["mac"] }
  it { is_expected.to have_db_index ["person_id"] }
  it { is_expected.to have_db_index ["vonage_product_id"] }

  # === Validations (Length) ===
  
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :sale_date }
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :location }
  it { is_expected.to validate_presence_of :customer_first_name }
  it { is_expected.to validate_presence_of :customer_last_name }
  it { is_expected.to validate_presence_of :vonage_product }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end