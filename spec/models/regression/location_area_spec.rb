require 'rails_helper'

RSpec.describe LocationArea, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :location }
  it { is_expected.to belong_to :area }
  
  it { is_expected.to have_many :candidates }
  it { is_expected.to have_many :day_sales_counts }
  it { is_expected.to have_many :versions }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :location_id }
  it { is_expected.to have_db_column :area_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :current_head_count }
  it { is_expected.to have_db_column :potential_candidate_count }
  it { is_expected.to have_db_column :target_head_count }
  it { is_expected.to have_db_column :active }
  it { is_expected.to have_db_column :hourly_rate }
  it { is_expected.to have_db_column :offer_extended_count }
  it { is_expected.to have_db_column :outsourced }
  it { is_expected.to have_db_column :launch_group }
  it { is_expected.to have_db_column :distance_to_cor }
  it { is_expected.to have_db_column :priority }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["area_id"] }
  it { is_expected.to have_db_index ["area_id", "location_id"] }
  it { is_expected.to have_db_index ["location_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :location }
  it { is_expected.to validate_presence_of :area }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end