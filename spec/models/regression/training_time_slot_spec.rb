require 'rails_helper'

RSpec.describe TrainingTimeSlot, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :training_class_type }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :training_class_type_id }
  it { is_expected.to have_db_column :start_date }
  it { is_expected.to have_db_column :end_date }
  it { is_expected.to have_db_column :monday }
  it { is_expected.to have_db_column :tuesday }
  it { is_expected.to have_db_column :wednesday }
  it { is_expected.to have_db_column :thursday }
  it { is_expected.to have_db_column :friday }
  it { is_expected.to have_db_column :saturday }
  it { is_expected.to have_db_column :sunday }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }
  it { is_expected.to have_db_index ["training_class_type_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :training_class_type_id }
  it { is_expected.to validate_presence_of :start_date }
  it { is_expected.to validate_presence_of :end_date }
  it { is_expected.to validate_presence_of :person_id }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end