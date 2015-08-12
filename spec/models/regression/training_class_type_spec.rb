require 'rails_helper'

RSpec.describe TrainingClassType, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :project }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :project_id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :ancestry }
  it { is_expected.to have_db_column :max_attendance }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["ancestry"] }
  it { is_expected.to have_db_index ["project_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :project_id }
  it { is_expected.to validate_presence_of :name }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end