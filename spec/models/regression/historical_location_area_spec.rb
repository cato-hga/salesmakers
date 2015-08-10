require 'rails_helper'

RSpec.describe HistoricalLocationArea, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :historical_location }
  it { is_expected.to belong_to :historical_area }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :historical_location_id }
  it { is_expected.to have_db_column :historical_area_id }
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
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :date }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["date"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :historical_location }
  it { is_expected.to validate_presence_of :historical_area }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end