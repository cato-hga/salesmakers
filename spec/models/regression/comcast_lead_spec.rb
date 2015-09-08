require 'rails_helper'

RSpec.describe ComcastLead, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :comcast_customer }
  it { is_expected.to have_one :comcast_sale }
  it { is_expected.to have_many :log_entries }

  # === Nested Attributes ===
  it { is_expected.to accept_nested_attributes_for :comcast_customer }

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :comcast_customer_id }
  it { is_expected.to have_db_column :follow_up_by }
  it { is_expected.to have_db_column :tv }
  it { is_expected.to have_db_column :internet }
  it { is_expected.to have_db_column :phone }
  it { is_expected.to have_db_column :security }
  it { is_expected.to have_db_column :ok_to_call_and_text }
  it { is_expected.to have_db_column :comments }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :active }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["comcast_customer_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :comcast_customer }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end