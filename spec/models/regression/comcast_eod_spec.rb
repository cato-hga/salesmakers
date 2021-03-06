require 'rails_helper'

RSpec.describe ComcastEod, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :location }
  it { is_expected.to belong_to :person }
  
  it { is_expected.to have_many :log_entries }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :eod_date }
  it { is_expected.to have_db_column :location_id }
  it { is_expected.to have_db_column :sales_pro_visit }
  it { is_expected.to have_db_column :sales_pro_visit_takeaway }
  it { is_expected.to have_db_column :comcast_visit }
  it { is_expected.to have_db_column :comcast_visit_takeaway }
  it { is_expected.to have_db_column :cloud_training }
  it { is_expected.to have_db_column :cloud_training_takeaway }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :person_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["location_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :location_id }
  it { is_expected.to validate_presence_of :person_id }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end