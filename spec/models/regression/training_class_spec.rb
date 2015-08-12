require 'rails_helper'

RSpec.describe TrainingClass, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :training_class_type }
  it { is_expected.to belong_to :training_time_slot }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :training_class_type_id }
  it { is_expected.to have_db_column :training_time_slot_id }
  it { is_expected.to have_db_column :date }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }
  it { is_expected.to have_db_index ["training_class_type_id"] }
  it { is_expected.to have_db_index ["training_time_slot_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :training_class_type_id }
  it { is_expected.to validate_presence_of :training_time_slot_id }
  it { is_expected.to validate_presence_of :person_id }
  it { is_expected.to validate_presence_of :date }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end