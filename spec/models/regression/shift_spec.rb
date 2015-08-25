require 'rails_helper'

RSpec.describe Shift, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :location }
  it { is_expected.to belong_to :project }
  it { is_expected.to have_one :vcp07012015_hps_shift }
  it { is_expected.to have_one :vcp07012015_vested_sales_shift }
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :location_id }
  it { is_expected.to have_db_column :date }
  it { is_expected.to have_db_column :hours }
  it { is_expected.to have_db_column :break_hours }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :training }
  it { is_expected.to have_db_column :project_id }
  it { is_expected.to have_db_column :meeting }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["date"] }
  it { is_expected.to have_db_index ["location_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :hours }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end