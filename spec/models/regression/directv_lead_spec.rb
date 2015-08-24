require 'rails_helper'

RSpec.describe DirecTVLead, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :directv_customer }
  it { is_expected.to have_one :directv_sale }
  it { is_expected.to have_many :log_entries }

  # === Nested Attributes ===
  it { is_expected.to accept_nested_attributes_for :directv_customer }

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :active }
  it { is_expected.to have_db_column :directv_customer_id }
  it { is_expected.to have_db_column :comments }
  it { is_expected.to have_db_column :follow_up_by }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :ok_to_call_and_text }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["directv_customer_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :directv_customer }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end