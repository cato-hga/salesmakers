require 'rails_helper'

RSpec.describe TrainingClassAttendee, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :training_class }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :training_class_id }
  it { is_expected.to have_db_column :attended }
  it { is_expected.to have_db_column :dropped_off_time }
  it { is_expected.to have_db_column :drop_off_reason_id }
  it { is_expected.to have_db_column :status }
  it { is_expected.to have_db_column :conditional_pass_condition }
  it { is_expected.to have_db_column :group_me_setup }
  it { is_expected.to have_db_column :time_clock_setup }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }
  it { is_expected.to have_db_index ["training_class_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :person_id }
  it { is_expected.to validate_presence_of :training_class_id }
  it { is_expected.to validate_presence_of :status }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end