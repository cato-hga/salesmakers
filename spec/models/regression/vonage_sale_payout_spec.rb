require 'rails_helper'

RSpec.describe VonageSalePayout, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :vonage_sale }
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :vonage_paycheck }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :vonage_sale_id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :payout }
  it { is_expected.to have_db_column :vonage_paycheck_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :day_62 }
  it { is_expected.to have_db_column :day_92 }
  it { is_expected.to have_db_column :day_122 }
  it { is_expected.to have_db_column :day_152 }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }
  it { is_expected.to have_db_index ["vonage_paycheck_id"] }
  it { is_expected.to have_db_index ["vonage_sale_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :vonage_sale }
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :payout }
  it { is_expected.to validate_presence_of :vonage_paycheck }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end