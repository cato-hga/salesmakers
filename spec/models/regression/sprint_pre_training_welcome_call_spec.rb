require 'rails_helper'

RSpec.describe SprintPreTrainingWelcomeCall, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :candidate }
  it { is_expected.to have_one :training_availability }
  

  # === Nested Attributes ===
  it { is_expected.to accept_nested_attributes_for :candidate }

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :still_able_to_attend }
  it { is_expected.to have_db_column :comment }
  it { is_expected.to have_db_column :group_me_reviewed }
  it { is_expected.to have_db_column :group_me_confirmed }
  it { is_expected.to have_db_column :cloud_reviewed }
  it { is_expected.to have_db_column :cloud_confirmed }
  it { is_expected.to have_db_column :epay_reviewed }
  it { is_expected.to have_db_column :epay_confirmed }
  it { is_expected.to have_db_column :candidate_id }
  it { is_expected.to have_db_column :status }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["candidate_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :candidate_id }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  it { is_expected.to define_enum_for(:status).with(["pending", "started", "completed"]) }
  
end