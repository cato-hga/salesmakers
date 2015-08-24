require 'rails_helper'

RSpec.describe DirecTVCustomer, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :location }
  it { is_expected.to belong_to :directv_lead_dismissal_reason }
  it { is_expected.to have_one :directv_lead }
  it { is_expected.to have_one :directv_sale }
  it { is_expected.to have_many :directv_customer_notes }
  it { is_expected.to have_many :log_entries }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :first_name }
  it { is_expected.to have_db_column :last_name }
  it { is_expected.to have_db_column :mobile_phone }
  it { is_expected.to have_db_column :other_phone }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :comments }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :location_id }
  it { is_expected.to have_db_column :directv_lead_dismissal_reason_id }
  it { is_expected.to have_db_column :dismissal_comment }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["location_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :location }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end