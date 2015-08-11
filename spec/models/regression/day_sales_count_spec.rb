require 'rails_helper'

RSpec.describe DaySalesCount, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :saleable }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :day }
  it { is_expected.to have_db_column :saleable_id }
  it { is_expected.to have_db_column :saleable_type }
  it { is_expected.to have_db_column :sales }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :activations }
  it { is_expected.to have_db_column :new_accounts }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["saleable_id", "saleable_type"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :day }
  it { is_expected.to validate_presence_of :saleable }
  it { is_expected.to validate_presence_of :sales }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end