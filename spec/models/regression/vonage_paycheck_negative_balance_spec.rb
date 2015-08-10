require 'rails_helper'

RSpec.describe VonagePaycheckNegativeBalance, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :vonage_paycheck }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :balance }
  it { is_expected.to have_db_column :vonage_paycheck_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }
  it { is_expected.to have_db_index ["vonage_paycheck_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :balance }
  it { is_expected.to validate_presence_of :vonage_paycheck }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end