require 'rails_helper'

RSpec.describe PrescreenAnswer, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :candidate }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :candidate_id }
  it { is_expected.to have_db_column :worked_for_salesmakers }
  it { is_expected.to have_db_column :of_age_to_work }
  it { is_expected.to have_db_column :eligible_smart_phone }
  it { is_expected.to have_db_column :can_work_weekends }
  it { is_expected.to have_db_column :reliable_transportation }
  it { is_expected.to have_db_column :ok_to_screen }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :worked_for_sprint }
  it { is_expected.to have_db_column :high_school_diploma }
  it { is_expected.to have_db_column :visible_tattoos }
  it { is_expected.to have_db_column :worked_for_radioshack }
  it { is_expected.to have_db_column :former_employment_date_start }
  it { is_expected.to have_db_column :former_employment_date_end }
  it { is_expected.to have_db_column :store_number_city_state }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["candidate_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :candidate_id }
  it { is_expected.to validate_presence_of :of_age_to_work }
  it { is_expected.to validate_presence_of :eligible_smart_phone }
  it { is_expected.to validate_presence_of :can_work_weekends }
  it { is_expected.to validate_presence_of :reliable_transportation }
  it { is_expected.to validate_presence_of :worked_for_sprint }
  it { is_expected.to validate_presence_of :high_school_diploma }
  it { is_expected.to validate_presence_of :visible_tattoos }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end