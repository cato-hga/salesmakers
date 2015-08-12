require 'rails_helper'

RSpec.describe SalesPerformanceRank, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :rankable }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :day }
  it { is_expected.to have_db_column :rankable_id }
  it { is_expected.to have_db_column :rankable_type }
  it { is_expected.to have_db_column :day_rank }
  it { is_expected.to have_db_column :week_rank }
  it { is_expected.to have_db_column :month_rank }
  it { is_expected.to have_db_column :year_rank }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["rankable_id", "rankable_type"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end